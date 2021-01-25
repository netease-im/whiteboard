# Whiteboard
云信互动白板基于云信实时通信网络，提供完整的多人实时白板互动服务。本仓库主要展视互动白板的 SDK 和 WebView 集成示例项目，帮助开发者自由、快速构建互动白板能力。

## 接口
  @interface NMCWhiteboardManager : NSObject

  @property(nonatomic, weak) id<NMCWhiteboardManagerDelegate> delegate;

  + (instancetype)sharedManager;

  - (WKWebView *)createWebViewFrame:(CGRect)frame;

  /**
   调用web登录，再页面加载之后

   @param loginParam 登录参数
   */
  - (void)callWebLoginIM:(NMCWebLoginParam *)loginParam;

  /**
   调用web退出登录，当不再使用白板之后
   */
  - (void)callWebLogoutIM;

  /**
   设置白板是否可以绘制

   @param enable 是否可用
   */
  - (void)callEnableDraw:(BOOL)enable;

  /**
   设置白板颜色

   @param color 白板颜色
   */
  - (void)setWhiteboardColor:(NSString *)color;

  @end

## 回调
  @protocol NMCWhiteboardManagerDelegate <NSObject>

  /**
   web页面加载完成
   */
  - (void)onWebPageLoaded;

  /**
   web登录IM成功,可以忽略
   */
  - (void)onWebLoginIMSucceed;

  /**
   web创建白板房间成功,可以忽略
   */
  - (void)onWebCreateWBSucceed;

  /**
   web加入白板房间成功,可以忽略
   */
  - (void)onWebJoinWBSucceed;

  /**
   提示web登录IM的错误及原因
   
   @param code 错误码
   @param error 具体错误信息
   */
  - (void)onWebLoginIMFailed:(NSInteger)code error:(NSString *)error;

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

  @end

