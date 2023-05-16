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