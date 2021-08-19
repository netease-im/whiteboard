//
//  NMCWhiteBoardManager.m
//  WhiteBoardWebDemo
//
//  Created by zhangchenliang on 2021/7/7.
//

#import "NMCWhiteBoardManager.h"
#import "NMCWebViewDefine.h"
#import "NMCWebView.h"
#import "NMCMessageDispatcher.h"

#import <CommonCrypto/CommonCrypto.h>

@interface NMCWhiteBoardManager ()<WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler>

@property (nonatomic, strong) NMCWebView *webView;

@property (nonatomic, weak) id<NMCWhiteboardManagerWKDelegate> wkDelegate;

@end

@implementation NMCWhiteBoardManager

#pragma mark - Public

+ (instancetype)sharedManager {
    static NMCWhiteBoardManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[NMCWhiteBoardManager alloc] init];
    });
    
    return manager;
}

- (void)configureDelegate:(id<NMCWhiteboardManagerDelegate>)delegate {
    [[NMCMessageDispatcher sharedDispatcher] configureDelegate:delegate];
}

- (void)confiureWKDelegate:(id<NMCWhiteboardManagerWKDelegate>)wkDelegate {
    _wkDelegate = wkDelegate;
}

- (WKWebView *)createWebViewWithFrame:(CGRect)frame {
    if (!_webView) {
        _webView = [[NMCWebView alloc] initWithFrame:frame scriptMessageHandler:self];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.scrollView.backgroundColor = [UIColor clearColor];
        _webView.scrollView.scrollEnabled = NO;
        _webView.scrollView.bounces = NO;
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 12.0) {
            if (@available(iOS 11.0, *)) {
                _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            }
        }
        
        if (@available(iOS 12.0, *)) {
            _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
        }
    }
    
    return _webView;
}

- (void)callWebLoginWithParam:(NMCWebLoginParam *)param {
    NSMutableDictionary *loginParam = [NSMutableDictionary dictionary];
    
    [loginParam setObject:param.channelName forKey:@"channelName"];
    [loginParam setObject:param.appKey forKey:@"appKey"];
    [loginParam setObject:@(param.uid) forKey:@"uid"];
    [loginParam setObject:@(param.record) forKey:@"record"];
    [loginParam setObject:@(param.debug) forKey:@"debug"];
    [loginParam setObject:@"ios" forKey:@"platform"];
    [loginParam setObject:@{} forKey:@"toolbar"];
    
    [[NMCMessageDispatcher sharedDispatcher] nativeCallWebWithWebView:_webView action:NMCMethodActionWebLogin param:loginParam];
}

- (void)callWebLogout {
    [[NMCMessageDispatcher sharedDispatcher] nativeCallWebWithWebView:_webView action:NMCMethodActionWebLogout param:[NSMutableDictionary dictionary]];
}

- (void)callWebEnableDraw:(BOOL)enable {
    NSDictionary *targetParam = @{@"target": NMCMethodTargetDrawPlugin, @"action": NMCMethodTargetActionEnableDraw, @"params": @[@(enable)]};
    [[NMCMessageDispatcher sharedDispatcher] nativeCallWebWithWebView:_webView action:NMCMethodActionJSDirectCall param:targetParam];
}

- (void)callWebSendAuthWithAppSecret:(NSString *)appSecret {
    NSMutableDictionary *targetParam = [NSMutableDictionary dictionary];
    
//    // 示例
//    NSString *nonce = @"670931.0681341566";
//    NSString *timeString = @"1624416784";
//    NSString *checkSum = @"09a913753e2f16216d40272575af1925c525df81";
    
    NSString *nonce = @"8788";
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval timeStamp = [date timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%0.f", timeStamp];
    
    NSMutableString *inputString = [NSMutableString stringWithString:appSecret];
    [inputString appendString:nonce];
    [inputString appendString:timeString];
    NSString *checkSum = [self generateSha1HexStringWithInputString:inputString];
    
    [targetParam setObject:@(200) forKey:@"code"];
    [targetParam setObject:nonce forKey:@"nonce"];
    [targetParam setObject:timeString forKey:@"curTime"];
    [targetParam setObject:checkSum forKey:@"checksum"];
    
    [[NMCMessageDispatcher sharedDispatcher] nativeCallWebWithWebView:_webView action:NMCMethodActionSendAuth param:targetParam];
}

#pragma mark - Private

- (UIViewController *)getTopViewController {
    for (UIView *next = [_webView superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    
    return nil;
}

- (NSString *)generateSha1HexStringWithInputString:(NSString *)inputString {
    NSData *stringData = [inputString dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(stringData.bytes, (CC_LONG)stringData.length, digest);
    NSMutableString *outputString = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [outputString appendFormat:@"%02x", digest[i]];
    }
    
    return outputString;
}

#pragma mark - WKUIDelegate

- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    NSLog(@"[WKUIDelegate] createWebViewWithConfiguration");
    
    return webView;
}

- (void)webViewDidClose:(WKWebView *)webView {
    NSLog(@"[WKUIDelegate] webViewDidClose");
}

// 提示框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    NSLog(@"[WKUIDelegate] runJavaScriptAlertPanelWithMessage");
    
    UIViewController *vc = [self getTopViewController];
    if (vc && vc.isViewLoaded && _webView && [_webView superview]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message ? message : @"" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            completionHandler();
        }]];
        [vc presentViewController:alert animated:YES completion:NULL];
    } else {
        completionHandler();
    }
}

// 确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    NSLog(@"[WKUIDelegate] runJavaScriptConfirmPanelWithMessage");
    
    UIViewController *vc = [self getTopViewController];
    if (vc && vc.isViewLoaded && _webView && [_webView superview]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message ? message : @"" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            completionHandler(YES);
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            completionHandler(NO);
        }]];
        [vc presentViewController:alert animated:YES completion:NULL];
    } else {
        completionHandler(NO);
    }
}

// 输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable result))completionHandler {
    NSLog(@"[WKUIDelegate] runJavaScriptTextInputPanelWithPrompt");
    
    UIViewController *vc = [self getTopViewController];
    if (vc && vc.isViewLoaded && _webView && [_webView superview]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:prompt ? prompt : @"" preferredStyle:UIAlertControllerStyleAlert];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.textColor = [UIColor blackColor];
            textField.placeholder = defaultText ? defaultText : @"";
        }];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            completionHandler([[alert.textFields lastObject] text]);
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            completionHandler(nil);
        }]];
        [vc presentViewController:alert animated:YES completion:NULL];
    } else {
        completionHandler(nil);
    }
}

#pragma mark - WKNavigationDelegate

// 发送请求之前决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString *requestString = navigationAction.request.URL.absoluteString;
    NSLog(@"[WKNavigationDelegate] decidePolicyForNavigationAction requestString = %@", requestString);
    
    if ([_wkDelegate respondsToSelector:@selector(onDecidePolicyForNavigationAction:decisionHandler:)]) {
        [_wkDelegate onDecidePolicyForNavigationAction:navigationAction decisionHandler:decisionHandler];
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

// 在收到响应后，决定是否跳转（表示当客户端收到服务器的响应头，根据response相关信息，可以决定这次跳转是否可以继续进行）
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    NSURLResponse *response = navigationResponse.response;
    NSLog(@"[WKNavigationDelegate] decidePolicyForNavigationResponse response = %@", response);
    
    if ([_wkDelegate respondsToSelector:@selector(onDecidePolicyForNavigationResponse:decisionHandler:)]) {
        [_wkDelegate onDecidePolicyForNavigationResponse:navigationResponse decisionHandler:decisionHandler];
    } else {
        decisionHandler(WKNavigationResponsePolicyAllow);
    }
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    NSLog(@"[WKNavigationDelegate] didReceiveAuthenticationChallenge");
    
    // 忽略不受信任的https证书
    // 若不配置，则上传图片会失败
    NSURLCredential *credential = [[NSURLCredential alloc] initWithTrust:challenge.protectionSpace.serverTrust];
    completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
}

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"[WKNavigationDelegate] didStartProvisionalNavigation");
}

// 接收到服务器跳转请求之后调用（接收服务器重定向时）
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"[WKNavigationDelegate] didReceiveServerRedirectForProvisionalNavigation");
}

// 加载失败时调用（加载内容时发生错误时）
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"[WKNavigationDelegate] didFailProvisionalNavigation error = %@", error);
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"[WKNavigationDelegate] didCommitNavigation");
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"[WKNavigationDelegate] didFinishNavigation");
    
    // 防止webView在长按之后触发手势出现系统自带的菜单
    [webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';"
              completionHandler:nil];
    [webView evaluateJavaScript:@"document.documentElement.style.webkitUserSelect='none';"
              completionHandler:nil];
}

// 导航期间发生错误时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"WKNavigationDelegate didFailNavigation error = %@", error);
}

// iOS9.0以上异常终止时调用
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    NSLog(@"[WKNavigationDelegate] webViewWebContentProcessDidTerminate");
    
    [webView reload];
}

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    // 获取到js脚本传过来的参数
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:message.body];
    
    NSString *action = params[NMCMethodAction];
    NSDictionary *param = params[NMCMethodParam];
    
    [[NMCMessageDispatcher sharedDispatcher] webCallNativeWithWebView:message.webView action:action param:param];
}

@end
