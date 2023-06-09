//
//  NTESWhiteBoardViewController.m
//  WhiteBoardWebDemo
//
//  Created by zhangchenliang on 2021/7/7.
//

#import "NTESWhiteBoardViewController.h"
#import "NTESHeaderView.h"
#import "NMCWhiteBoardManager.h"
#import "NSDictionary+NERtc.h"

#import <Photos/Photos.h>
#import <WebKit/WebKit.h>
#import <Masonry/Masonry.h>
#import <Toast/UIView+Toast.h>

#define UIColorFromRGBA(rgbValue, alphaValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:alphaValue]

@interface NTESWhiteBoardViewController ()<NTESHeaderViewDelegate, NMCWhiteboardManagerDelegate, NMCWhiteboardManagerWKDelegate>

@property (nonatomic, strong) NTESWhiteBoardParam *whiteBoardParam;
@property (nonatomic, strong) NTESHeaderView *headerView;
@property (nonatomic, strong) WKWebView *webView;

@end

@implementation NTESWhiteBoardViewController

#pragma mark - Life Cycle

- (void)dealloc {
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (@available(iOS 11.0, *)) {
        
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self setupLayout];
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_whiteBoardParam.webViewUrl]]];
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    [[NMCWhiteBoardManager sharedManager] configureDelegate:self];
    [[NMCWhiteBoardManager sharedManager] confiureWKDelegate:self];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    UIEdgeInsets safeAreaInsets = UIEdgeInsetsZero;
    if (@available(iOS 11.0, *)) {
        safeAreaInsets = [UIApplication sharedApplication].keyWindow.safeAreaInsets;
    } else {
        if ([UIDevice currentDevice].orientation == UIDeviceOrientationPortrait) {
            safeAreaInsets = UIEdgeInsetsMake(20, 0, 0, 0);
        }
    }
    
    [_headerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(safeAreaInsets.top);
        make.left.equalTo(self.view).offset(safeAreaInsets.left);
        make.right.equalTo(self.view).offset(-safeAreaInsets.right);
    }];
    
    [_webView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(safeAreaInsets.left);
        make.right.equalTo(self.view).offset(-safeAreaInsets.right);
        make.bottom.equalTo(self.view).offset(-safeAreaInsets.bottom);
    }];
    
    [_headerView setNeedsLayout];
    [_headerView layoutIfNeeded];
    [_webView setNeedsLayout];
    [_webView layoutIfNeeded];
}

#pragma mark - Public

- (instancetype)initWithWhiteBoardParam:(NTESWhiteBoardParam *)whiteBoardParam {
    self = [super init];
    if (self) {
        _whiteBoardParam = whiteBoardParam;
    }
    
    return self;
}

#pragma mark - Private

- (void)setupLayout {
    UIEdgeInsets safeAreaInsets = UIEdgeInsetsZero;
    if (@available(iOS 11.0, *)) {
        safeAreaInsets = [UIApplication sharedApplication].keyWindow.safeAreaInsets;
    } else {
        if ([UIDevice currentDevice].orientation == UIDeviceOrientationPortrait) {
            safeAreaInsets = UIEdgeInsetsMake(20, 0, 0, 0);
        }
    }
    
    [self.view addSubview:self.headerView];
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(safeAreaInsets.top);
        make.left.equalTo(self.view).offset(safeAreaInsets.left);
        make.right.equalTo(self.view).offset(-safeAreaInsets.right);
        make.height.mas_equalTo(40);
    }];
    
    [self.view addSubview:self.webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headerView.mas_bottom);
        make.left.equalTo(self.view).offset(safeAreaInsets.left);
        make.right.equalTo(self.view).offset(-safeAreaInsets.right);
        make.bottom.equalTo(self.view).offset(-safeAreaInsets.bottom);
    }];
    
    [_headerView refreshWithRoomId:_whiteBoardParam.channelName userName:@""];
}

- (void)handleResult:(NSString *)result {
    if (result && result.length > 0) {
        [self.view makeToast:result duration:2.0 position:CSToastPositionCenter];
        [self leaveRoom];
    }
}

- (void)leaveRoom {
    [[NMCWhiteBoardManager sharedManager] callWebLogout];
    
    [_webView stopLoading];
    [self clearWebViewCache];
}

- (void)clearWebViewCache {
    if ([[[UIDevice currentDevice]systemVersion]intValue ] >= 9.0) {
        NSArray * types = @[WKWebsiteDataTypeMemoryCache,WKWebsiteDataTypeDiskCache];
        NSSet *websiteDataTypes = [NSSet setWithArray:types];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{}];
    } else {
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES) objectAtIndex:0];
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        NSLog(@"%@", cookiesFolderPath);
        NSError *errors;
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
    }
}

- (NMCWebLoginParam *)generateWebLoginParamWithParam:(NTESWhiteBoardParam *)param {
    NMCWebLoginParam *loginParam = [[NMCWebLoginParam alloc] init];
    loginParam.channelName = param.channelName;
    loginParam.appKey = param.appKey;
    loginParam.uid = param.uid;
    loginParam.record = YES;
    loginParam.debug = YES;
    
    return loginParam;
}

#pragma mark - NTESHeaderViewDelegate

- (void)didTriggerExitAction {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"退出房间？" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self leaveRoom];
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - NMCWhiteboardManagerDelegate

- (void)onWebPageLoaded {
    NSLog(@"[demo] ===> onWebPageLoaded");
    
    NMCWebLoginParam *loginParam = [self generateWebLoginParamWithParam:_whiteBoardParam];
    [[NMCWhiteBoardManager sharedManager] callWebLoginWithParam:loginParam];
}

- (void)onWebCreateWBSucceed {
    NSLog(@"[demo] ===> onWebCreateWBSucceed");
}

- (void)onWebJoinWBSucceed {
    NSLog(@"[demo] ===> onWebJoinWBSucceed");
    
    [[NMCWhiteBoardManager sharedManager] callWebEnableDraw:YES];
}

- (void)onWebJoinWBFailed:(NSInteger)code error:(NSString *)error {
    NSLog(@"[demo] ===> onWebJoinWBFailed : %ld, %@",(long)code, error);
    
    [self handleResult:error];
}

- (void)onWebCreateWBFailed:(NSInteger)code error:(NSString *)error {
    NSLog(@"[demo] ===> onWebCreateWBFailed : %ld, %@",(long)code, error);
    
    [self handleResult:error];
}

- (void)onWebLeaveWB {
    NSLog(@"[demo] ===> onWebLeaveWB");
    
    [_webView stopLoading];
    [self clearWebViewCache];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onWebError:(NSInteger)code error:(NSString *)error {
    NSLog(@"[demo] ===> onWebError : %ld, %@",(long)code, error);
    
    [self handleResult:error];
}

- (void)onWebJsError:(NSString *)error {
    NSLog(@"[demo] ===> onWebJsError : %@", error);
}

- (void)onWebGetAuth {
    NSLog(@"[demo] ===> onWebGetAuth");
    
    [[NMCWhiteBoardManager sharedManager] callWebSendAuthWithAppKey:self.whiteBoardParam.appKey channelName:self.whiteBoardParam.channelName userId:self.whiteBoardParam.uid];
}

- (void)onWebGetAntiLeechInfoWithParams:(NSDictionary *)params {
    NSLog(@"[demo] ===> onWebGetAntiLeechInfo");
    
    NSDictionary* prop = [params objectForKey:@"prop"];
    NSString* bucketName = [prop nertc_jsonString:@"bucket"];
    NSString* objectKey = [prop nertc_jsonString:@"object"];
    NSInteger seqId = [params nertc_jsonInteger:@"seqId"];
    NSString* url = [params nertc_jsonString:@"url"];
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    NSString* timeStamp = [NSString stringWithFormat:@"%llu", @(currentTime).unsignedLongLongValue];
    [[NMCWhiteBoardManager sharedManager] callWebSendAntiLeechInfoWithAppKey:self.whiteBoardParam.appKey bucketName:bucketName objectKey:objectKey url:url seqId:seqId timeStamp:timeStamp];
}

#pragma mark - NMCWhiteboardManagerWKDelegate

- (void)onDecidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if ([self needSaveImage:navigationAction]) {
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)onDecidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    decisionHandler(WKNavigationResponsePolicyAllow);
}

#pragma mark - Save Image

- (BOOL)needSaveImage:(WKNavigationAction *)navigationAction {
    NSString *requestString = navigationAction.request.URL.absoluteString;
    NSRange pngKeywordRange = [requestString rangeOfString:@"data:image/png;base64,"];
    NSRange jpegKeywordRange = [requestString rangeOfString:@"data:image/jpeg;base64,"];
    BOOL isValidImageString = (pngKeywordRange.location != NSNotFound) || (jpegKeywordRange.location != NSNotFound);
    if ((navigationAction.navigationType == WKNavigationTypeLinkActivated) && isValidImageString) {
        NSString *dataString = nil;
        if (pngKeywordRange.location != NSNotFound) {
            dataString = [requestString stringByReplacingCharactersInRange:pngKeywordRange withString:@""];
        } else {
            dataString = [requestString stringByReplacingCharactersInRange:jpegKeywordRange withString:@""];
        }
        
        NSData *imageData = [[NSData alloc] initWithBase64EncodedString:dataString options:NSDataBase64DecodingIgnoreUnknownCharacters];
        UIImage *image = [UIImage imageWithData:imageData];
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusNotDetermined) {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {
                    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void*)self);
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.view makeToast:@"请开启相册权限" duration:2.0 position:CSToastPositionCenter];
                    });
                }
            }];
            
            return YES;
        }
        if (status == PHAuthorizationStatusAuthorized) {
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void*)self);
        } else {
            [self.view makeToast:@"请开启相册访问权限" duration:2.0 position:CSToastPositionCenter];
        }
        
        return YES;
    }
    
    return NO;
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo: (void *)contextInfo {
    if (error != nil) {
        NSLog(@"Image Can not be saved");
        NSString *errMsg = [NSString stringWithFormat:@"图片保存失败%@", error.localizedDescription];
        [self.view makeToast:errMsg duration:2.0 position:CSToastPositionCenter];
    } else {
        NSLog(@"Successfully saved Image");
        [self.view makeToast:@"图片保存成功" duration:2.0 position:CSToastPositionCenter];
    }
}

#pragma mark - Getter

-(WKWebView *)webView {
    if (!_webView) {
        _webView = [[NMCWhiteBoardManager sharedManager] createWebViewWithFrame:CGRectZero];
        _webView.layer.borderWidth = 1;
        _webView.layer.borderColor = UIColorFromRGBA(0xd7dade, 1.0).CGColor;
    }
    
    return _webView;
}

- (NTESHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[NTESHeaderView alloc] initWithFrame:CGRectZero];
        _headerView.delegate = self;
        _headerView.backgroundColor = UIColorFromRGBA(0xd7dade, 1.0);
    }
    
    return _headerView;
}

- (UIModalPresentationStyle)modalPresentationStyle {
    return UIModalPresentationFullScreen;
}

@end
