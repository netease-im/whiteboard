本开源项目主要展示互动白板 iOS 端如何快速集成互动白板 WebView 接入方案，帮助开发者实现互动白板能力。

> Note：github 上有大小写不敏感问题，同一目录下不要有两个大小写相同的文件夹，example: iOS、ios

sample code 仅作为展示使用。实际开发时，请不要将 app secret 放置在客户端代码中，以防泄漏。sample code 中放置 app secret 是为了开发者在没有设置应用服务器的情况下，即能够跑通白板的流程。

sample code 的启动流程如下：  
1. 进入目录 ios/WhiteBoardWebDemo/，打开WhiteBoardWebDemo.xcworkspace  
2. 在项目配置中选择 Signing & Capabilities，配置 team、bundle identifier 和 provisioning profile 等信息  
3. 选择设备（真机或模拟器），点击 “run” 即可

sample code 中获取 auth 的流程如下：  
1. webview 通过 webGetAuth 请求 auth  
2. 客户端生成 auth  
3. 客户端通过 jsSendAuth 返回 auth  

开发者应该创建应用服务器，将该流程改为：  
1. webview 通过 webGetAuth 请求 auth  
2. 客户端向应用服务器请求 auth  
3. 应用服务器生成 auth  
4. 应用服务器向客户端返回 auth  
5. 客户端通过 jsSendAuth 返回 auth  

## 接口
@interface NMCWhiteBoardManager : NSObject

+(instancetype)sharedManager;

-(void)configureDelegate:(id<NMCWhiteboardManagerDelegate>)delegate;

-(void)confiureWKDelegate:(id<NMCWhiteboardManagerWKDelegate>)wkDelegate;

-(WKWebView *)createWebViewWithFrame:(CGRect)frame;

/// 调用web登录，在页面加载完成之后执行  
/// @param param 登录参数  
- (void)callWebLoginWithParam:(NMCWebLoginParam *)param;

/// 调用web登出  
- (void)callWebLogout;

/// 设置白板是否可以绘制  
/// @param enable 是否可以绘制  
- (void)callWebEnableDraw:(BOOL)enable;

/// 给web发送鉴权信息  
/// @param appSecret appSecret  
- (void)callWebSendAuthWithAppSecret:(NSString *)appSecret;

@end

## 回调
@protocol NMCWhiteboardManagerDelegate <NSObject>

/**  
 web页面加载完成  
 */  
- (void)onWebPageLoaded;

/**  
 web创建白板房间成功,可以忽略  
 */  
- (void)onWebCreateWBSucceed;

/**  
 web加入白板房间成功,可以忽略  
 */  
- (void)onWebJoinWBSucceed;

/**  
 提示web加入白板房间的错误及原因  
 
 @param code 错误码  
 @param error 具体错误信息  
 */  
- (void)onWebJoinWBFailed:(NSInteger)code error:(NSString *)error;

/**  
 提示web创建白板房间的错误及原因  
 
 @param code 错误码  
 @param error 具体错误信息  
 */  
- (void)onWebCreateWBFailed:(NSInteger)code error:(NSString *)error;

/**  
 web离开白板房间  
 */  
- (void)onWebLeaveWB;

/**  
 web发生了网络异常  
 
 @param code 错误码  
 @param error 具体错误信息  
 */  
- (void)onWebError:(NSInteger)code error:(NSString *)error;

/**  
 web抛出Js错误
 
 @param error 具体错误信息  
 */  
- (void)onWebJsError:(NSString *)error;

/**  
 web需要鉴权信息  
 */  
- (void)onWebGetAuth;

@end

@protocol NMCWhiteboardManagerWKDelegate <NSObject>

@optional
/*! @abstract Decides whether to allow or cancel a navigation.
 @param navigationAction Descriptive information about the action
 triggering the navigation request.
 @param decisionHandler The decision handler to call to allow or cancel the
 navigation. The argument is one of the constants of the enumerated type WKNavigationActionPolicy.
 @discussion If you do not implement this method, the web view will load the request or, if appropriate, forward it to another application.
 */  
- (void)onDecidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler;

/*! @abstract Decides whether to allow or cancel a navigation after its
 response is known.
 @param navigationResponse Descriptive information about the navigation
 response.
 @param decisionHandler The decision handler to call to allow or cancel the
 navigation. The argument is one of the constants of the enumerated type WKNavigationResponsePolicy.
 @discussion If you do not implement this method, the web view will allow the response, if the web view can show it.
 */  
- (void)onDecidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler;

@end