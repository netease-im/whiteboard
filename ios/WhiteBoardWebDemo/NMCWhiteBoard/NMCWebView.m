//
//  NMCWebView.m
//  WhiteBoardWebDemo
//
//  Created by zhangchenliang on 2021/7/7.
//

#import "NMCWebView.h"
#import "NMCWebViewDefine.h"

@implementation NMCWebView

- (void)dealloc {
    // 清除 message handler
    [self.configuration.userContentController removeScriptMessageHandlerForName:NMCNativeMethodMessage];
    
    // 清除 user script
    [self.configuration.userContentController removeAllUserScripts];
    
    // 停止加载
    [self stopLoading];

    // 清空 delegate
    [super setUIDelegate:nil];
    [super setNavigationDelegate:nil];
}

- (instancetype)initWithFrame:(CGRect)frame scriptMessageHandler:(id<WKScriptMessageHandler>)scriptMessageHandler {
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    
    if ([config respondsToSelector:@selector(setAllowsInlineMediaPlayback:)]) {
        [config setAllowsInlineMediaPlayback:YES];
    }
    if (@available(iOS 10.0, *)) {
        if ([config respondsToSelector:@selector(setMediaTypesRequiringUserActionForPlayback:)]) {
            [config setMediaTypesRequiringUserActionForPlayback:WKAudiovisualMediaTypeNone];
        }
    } else {
        if ([config respondsToSelector:@selector(setRequiresUserActionForMediaPlayback:)]) {
            [config setRequiresUserActionForMediaPlayback:NO];
        }
        if ([config respondsToSelector:@selector(setMediaPlaybackRequiresUserAction:)]) {
            [config setMediaPlaybackRequiresUserAction:NO];
        }
    }
    
    self = [super initWithFrame:frame configuration:config];
    if (self) {
        [self configureWithScriptMessageHandler:scriptMessageHandler];
    }
    
    return self;
}

- (void)configureWithScriptMessageHandler:(id<WKScriptMessageHandler>)scriptMessageHandler {
    // 注入 JS
    NSString *scriptPath = [[NSBundle mainBundle] pathForResource:@"NMCJSBridge" ofType:@"js"];
    NSString *scriptString = [[NSString alloc] initWithContentsOfFile:scriptPath encoding:NSUTF8StringEncoding error:NULL];
    WKUserScript *userScript = [[WKUserScript alloc] initWithSource:scriptString injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    [self.configuration.userContentController addUserScript:userScript];
    
    // 指定 message handler
    [self.configuration.userContentController addScriptMessageHandler:scriptMessageHandler name:NMCNativeMethodMessage];
}

@end
