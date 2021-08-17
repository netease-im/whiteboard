本开源项目主要展示互动白板 Android 端如何快速集成互动白板 WebView 接入方案，帮助开发者实现互动白板能力。

## 目录结构

```md
WhiteboardAndroidDemo                  //webview接入示例   
com.netease.whiteboardandroiddemo.main.MainActivity //房间号填写页面
com.netease.whiteboardandroiddemo.whiteboard.WhiteboardActivity // 白板页面
com.netease.whiteboardandroiddemo.Constant // 存放常量，运行工程需要在此填入APP_KEY, APP_SECRET和WEBVIEW_URL
```

## 设置与运行

1. 用户先联系云信团队，询问appKey
2. 在Constant中填入自己的APP_KEY, APP_SECRET和WEBVIEW_URL
3. 通过Web或者PC端创建一个房间
4. 运行工程，在房间号填写页面填写创建号的房间号
5. 点击加入房间，注册并登陆IM，然后进入白板页面并打开白板

## 备注

samplecode仅作为展示使用。实际开发时，请不要将appsecret放置在客户端代码中，以防泄漏。客户端中放置appsecret是为了在客户不需要设置应用服务器时，即能够跑通白板的sample code。

sample code中获取auth的流程如下：
1. webview通过webGetAuth请求auth
2. 客户端生成auth
3. 客户端通过jsSendAuth返回auth

开发者应该创建应用服务器，将该流程改为：
1. webview通过webGetAuth请求auth
2. 客户端向应用服务器请求auth
3. 应用服务器生成auth
4. 应用服务器向客户端返回auth
5. 客户端通过jsSendAuth返回auth
