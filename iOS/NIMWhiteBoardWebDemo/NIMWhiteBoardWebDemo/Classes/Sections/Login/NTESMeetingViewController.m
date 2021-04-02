//
//  NTESMeetingViewController.m
//  NIMWhiteBoardWebDemo
//
//  Created by taojinliang on 2020/12/30.
//

#import "NTESMeetingViewController.h"
#import "UIView+Toast.h"
#import <WebKit/WebKit.h>
#import "NMCWhiteboardManager.h"
#import "NTESDemoConfig.h"
#import "NTESLoginManager.h"
#import "AppDelegate.h"
#import <UIKit/UIKit.h>
#import "UIDevice+Orientation.h"
#import "NTESHeaderView.h"
#import "UIAlertView+NTESBlock.h"
#import "UIView+NTES.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

#define kTitleViewHeight 40

@interface NTESMeetingViewController ()<NIMChatroomManagerDelegate, NIMLoginManagerDelegate, NMCWhiteboardManagerDelegate, NTESHeaderViewDelegate, NMCWhiteboardManagerWKDelegate>
@property (nonatomic, copy) NIMChatroom *chatroom;
@property (nonatomic, strong) WKWebView *webview;
@property (nonatomic, strong) NTESHeaderView *titleView;
@property (nonatomic, strong) NSArray *colorsArray;
@end

@implementation NTESMeetingViewController

NTES_USE_CLEAR_BAR
- (instancetype)initWithChatroom:(NIMChatroom *)chatroom{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _chatroom = chatroom;
        _colorsArray = @[@"rgb(224,32,32)",
                         @"rgb(250,100,0)",
                         @"rgb(247,181,0)",
                         @"rgb(109,212,0)",
                         @"rgb(68,215,182)",
                         @"rgb(50,197,255)",
                         @"rgb(0,145,255)",
                         @"rgb(98,54,255)",
                         @"rgb(182,32,224)",
                         @"rgb(109,114,120)"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBarHidden = YES;
    
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //允许转成横屏
    appDelegate.allowRotation = YES;
    
    [[NIMSDK sharedSDK].chatroomManager addDelegate:self];
    [[NIMSDK sharedSDK].loginManager addDelegate:self];
    [NMCWhiteboardManager sharedManager].delegate = self;
    [NMCWhiteboardManager sharedManager].wkDelegate = self;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.webview];
    NSUInteger offset = ([UIDevice currentDevice].orientation != UIDeviceOrientationLandscapeLeft && [UIDevice currentDevice].orientation != UIDeviceOrientationLandscapeRight) ? 40 : 0;
    
    self.titleView = [[NTESHeaderView alloc] initWithFrame:CGRectZero];
    [self.titleView refreshWithRoomId:self.chatroom.roomId user:[NTESLoginManager sharedManager].currentNTESLoginData.account];
    self.titleView.deleagte = self;
    self.titleView.backgroundColor = UIColorFromRGB(0xd7dade);
    [self.view addSubview:self.titleView];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(offset);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(self.view);
        make.height.mas_equalTo(kTitleViewHeight);
    }];
    [self.webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.titleView.bottom);
        make.width.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
    }];
    //开启和监听 设备旋转的通知（不开启的话，设备方向一直是UIInterfaceOrientationUnknown）
    if (![UIDevice currentDevice].generatesDeviceOrientationNotifications) {
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleDeviceOrientationChange:)
                                                name:UIDeviceOrientationDidChangeNotification object:nil];
}

//设备方向改变的处理
- (void)handleDeviceOrientationChange:(NSNotification *)notification{
    if([UIDevice currentDevice].systemVersion.doubleValue < 10.0) {
        dispatch_after(0.25, dispatch_get_main_queue(), ^{
            [self.webview setNeedsLayout];
            [self.webview layoutIfNeeded];
            //whiteboard
            __weak typeof(self) weakself = self;
            [self.webview.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if([obj isKindOfClass:NSClassFromString(@"WKContentView")]) {
                    obj.frame = weakself.webview.scrollView.bounds;
                    *stop = YES;
                }
            }];
        });
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    NSUInteger offset = ([UIDevice currentDevice].orientation != UIDeviceOrientationLandscapeLeft && [UIDevice currentDevice].orientation != UIDeviceOrientationLandscapeRight) ? 40 : 0;
    [self.titleView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(offset);
    }];
    [self.webview mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleView.bottom);
    }];
    [self.webview setNeedsLayout];
    [self.webview layoutIfNeeded];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}


- (void)dealloc{
    [[NIMSDK sharedSDK].chatroomManager exitChatroom:_chatroom.roomId completion:nil];
    [[NIMSDK sharedSDK].chatroomManager removeDelegate:self];
    [[NIMSDK sharedSDK].loginManager removeDelegate:self];
    [self leaveRoom];
    
    [self.titleView removeFromSuperview];
    
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[UIDevice currentDevice]endGeneratingDeviceOrientationNotifications];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    self.titleView.hidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    
    self.titleView.hidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)keyboardWillShow:(NSNotification*)notification {
    
}

- (void)keyboardWillHide:(NSNotification*)notification {
    
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (void)onExitRoom:(NSString *)text {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:text delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"退出", nil];
    [alert showAlertWithCompletionHandler:^(NSInteger index) {
        switch (index) {
            case 1:{
                [self leaveRoom];
                break;
            }
                
            default:
                break;
        }
    }];
}

- (void)onBeExitRoom:(NSString *)text {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:text delegate:nil cancelButtonTitle:nil otherButtonTitles:@"退出", nil];
    [alert showAlertWithCompletionHandler:^(NSInteger index) {
        switch (index) {
            case 0:{
                [self leaveRoom];
                break;
            }
                
            default:
                break;
        }
    }];
}

- (void)leaveRoom {
    [[NMCWhiteboardManager sharedManager] callWebLogoutIM];
    [self.webview reload];
    [self clearWebViewCache];
}

#pragma mark - NIMChatroomManagerDelegate
//被踢回调
- (void)chatroomBeKicked:(NIMChatroomBeKickedResult *)result {
    NSLog(@"[demo] chatroomBeKicked: %@", result);
    
    if ([result.roomId isEqualToString:self.chatroom.roomId]) {
        NSString *toast;
        if ([_chatroom.creator isEqualToString:[[NIMSDK sharedSDK].loginManager currentAccount]])
        {
            toast = @"教学已结束";
        }else {
            switch (result.reason) {
                case NIMChatroomKickReasonByManager:
                    toast = @"你已被老师请出房间";
                    break;
                case NIMChatroomKickReasonInvalidRoom:
                    toast = @"房间已结束教学，请确认退出！";
                    break;
                case NIMChatroomKickReasonByConflictLogin:
                    toast = @"你已被自己踢出了房间";
                    break;
                default:
                    toast = @"你已被踢出了房间";
                    break;
            }
        }
        
        DDLogInfo(@"[demo] chatroom be kicked, roomId:%@  reason:%@",result.roomId,toast);
        
        [self onBeExitRoom:toast];
    }
}

//聊天室连接状态变化
- (void)chatroom:(NSString *)roomId connectionStateChanged:(NIMChatroomConnectionState)state {
    NSLog(@"[demo] connectionStateChanged- roomId:%@, state:%ld", roomId, (long)state);
}

//聊天室自动登录出错
- (void)chatroom:(NSString *)roomId autoLoginFailed:(NSError *)error {
    NSLog(@"[demo] autoLoginFailed- roomId:%@, error:%@", roomId, error);
}

#pragma mark -NIMLoginManagerDelegate

//被踢(服务器/其他端)回调
- (void)onKickout:(NIMLoginKickoutResult *)result{
    NSLog(@"[demo] onKickout: %@", result);
    [self showToastView:result.reasonDesc];
}

//登录回调
- (void)onLogin:(NIMLoginStep)step{
    NSLog(@"[demo] onLogin: %ld", (long)step);
}

//自动登录失败回调
- (void)onAutoLoginFailed:(NSError *)error{
    NSLog(@"[demo] onAutoLoginFailed: %@", error);
}

//多端登录发生变化
- (void)onMultiLoginClientsChanged{
    NSLog(@"[demo] onMultiLoginClientsChanged");
}

//多端登录发生变化
- (void)onMultiLoginClientsChangedWithType:(NIMMultiLoginType)type{
    NSLog(@"[demo] onMultiLoginClientsChangedWithType: %ld", (long)type);
}

//群用户同步完成通知
- (void)onTeamUsersSyncFinished:(BOOL)success{
    NSLog(@"[demo] onTeamUsersSyncFinished: %@", @(success));
}

//超大群用户同步完成通知
- (void)onSuperTeamUsersSyncFinished:(BOOL)success{
    NSLog(@"[demo] onSuperTeamUsersSyncFinished: %@", @(success));
}


#pragma mark -whiteboard
- (WKWebView *)webview{
    if (!_webview) {
        _webview = [[NMCWhiteboardManager sharedManager] createWebViewFrame:CGRectZero];
        _webview.backgroundColor = [UIColor whiteColor];
        _webview.layer.borderWidth = 1;
        _webview.layer.borderColor = UIColorFromRGB(0xd7dade).CGColor;
        //        _webview.scrollView.backgroundColor = [UIColor redColor];
        //        _webview.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        //        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NTESDemoConfig sharedConfig].whiteBoardURL]];
        [_webview loadRequest:request];
        
        if([[[UIDevice currentDevice] systemVersion] floatValue] < 12.0) {
            if (@available(iOS 11.0, *)) {
                _webview.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            }
        }
        if (@available(iOS 12.0, *)) {
            _webview.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
        }
    }
    return _webview;
}

- (void)clearWebViewCache {
    if ([[[UIDevice currentDevice]systemVersion]intValue ] >= 9.0) {
        NSArray * types =@[WKWebsiteDataTypeMemoryCache,WKWebsiteDataTypeDiskCache]; // 9.0之后才有的
        NSSet *websiteDataTypes = [NSSet setWithArray:types];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{}];
    }else{
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES) objectAtIndex:0];
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        NSLog(@"%@", cookiesFolderPath);
        NSError *errors;
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
    }
}

#pragma mark - NMCWhiteboardManagerDelegate
- (void)onWebPageLoaded {
    NSLog(@"[demo] ===> onWebPageLoaded");
    
    NMCWebLoginParam *param = [[NMCWebLoginParam alloc] init];
    param.channelName = self.chatroom.roomId;
    param.debug = YES;
    //因为 在线教育demo使用的SDK版本是线上版本，所以登录的时候，传递的appkey应该用线上版本的appkey，至少暂时先这样
    param.appKey = [[NIMSDK sharedSDK] appKey];
    param.account = [NTESLoginManager sharedManager].currentNTESLoginData.account;
    param.token = [NTESLoginManager sharedManager].currentNTESLoginData.token;
    param.record = YES;
    param.ownerAccount = self.chatroom.creator;
    
    [[NMCWhiteboardManager sharedManager] callWebLoginIM:param];
}

- (void)onWebLoginIMSucceed {
    NSLog(@"[demo] ===> onWebLoginIMSucceed");
}

- (void)onWebCreateWBSucceed {
    NSLog(@"[demo] ===> onWebCreateWBSucceed");
}

- (void)onWebJoinWBSucceed {
    NSLog(@"[demo] ===> onWebJoinWBSucceed");
    
    [[NMCWhiteboardManager sharedManager] callEnableDraw:YES];
    if ([_chatroom.creator isEqualToString:[[NIMSDK sharedSDK].loginManager currentAccount]])
    {
        [[NMCWhiteboardManager sharedManager] setWhiteboardColor:@"rgb(0,0,0)"];
    }else{
        NSString *color = [self.colorsArray objectAtIndex:random()%10];
        [[NMCWhiteboardManager sharedManager] setWhiteboardColor:color];
    }
}

- (void)onWebLoginIMFailed:(NSInteger)code error:(NSString *)error {
    NSLog(@"[demo] ===> onWebLoginIMFailed : %ld, %@",(long)code, error);
    [self showToastView:error];
}

- (void)onWebJoinWBFailed:(NSInteger)code error:(NSString *)error {
    NSLog(@"[demo] ===> onWebJoinWBFailed : %ld, %@",(long)code, error);
    [self showToastView:error];
}

- (void)onWebCreateWBFailed:(NSInteger)code error:(NSString *)error {
    NSLog(@"[demo] ===> onWebCreateWBFailed : %ld, %@",(long)code, error);
    [self showToastView:error];
}

- (void)onWebLeaveWB {
    NSLog(@"[demo] ===> onWebLeaveWB");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onWebError:(NSInteger)code error:(NSString *)error {
    NSLog(@"[demo] ===> onWebError : %ld, %@",(long)code, error);
    [self showToastView:error];
}

- (void)onWebJsError:(NSString *)error {
    NSLog(@"[demo] ===> onWebError : %@", error);
}


- (void)showToastView:(NSString *)error {
    if (error && error.length > 0) {
        [self.view makeToast:error duration:2.0 position:CSToastPositionCenter];
        [self leaveRoom];
    }
}

#pragma mark- WK Delgate

- (void)onDecidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if([self needSaveImage:navigationAction]) {
        decisionHandler(WKNavigationActionPolicyCancel);
    }else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)onDecidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    decisionHandler(WKNavigationResponsePolicyAllow);
}

#pragma mark Save Image

- (BOOL)needSaveImage:(WKNavigationAction *)navigationAction {
    NSString *requestString = navigationAction.request.URL.absoluteString;
    NSLog(@"[WK] decidePolicyForNavigationAction %@",requestString);
    if(navigationAction.navigationType == WKNavigationTypeLinkActivated && [requestString rangeOfString:@"data:image/png;base64,"].location != NSNotFound) {
        NSString *dataString = [requestString stringByReplacingOccurrencesOfString:@"data:image/png;base64," withString:@""];
        NSData *imageData = [[NSData alloc]initWithBase64EncodedString:dataString options:NSDataBase64DecodingIgnoreUnknownCharacters];;
        UIImage *image = [UIImage imageWithData:imageData];
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if(status == PHAuthorizationStatusNotDetermined) {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                
            }];
        }
        if (status == PHAuthorizationStatusRestricted ||
            status == PHAuthorizationStatusDenied) {
            [self.view makeToast:@"请开启相册权限" duration:2.0 position:CSToastPositionCenter];
        }else {
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void*)self);
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

@end
