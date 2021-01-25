本开源项目主要展视互动白板 Android 端如何快速集成互动白板 WebView 接入方案，帮助开发者实现互动白板能力。

## 目录结构

```md
WhiteboardAndroidDemo                  //webview接入示例   
com.netease.whiteboardandroiddemo.main.MainActivity //房间号填写页面
com.netease.whiteboardandroiddemo.whiteboard.WhiteboardActivity // 白板页面
com.netease.whiteboardandroiddemo.Constant // 存放常量，运行工程需要在此填入APP_KEY, LOAD_URL和API_SERVER
```

## 设置与运行

1. 用户先联系云信团队，询问appKey
2. 在Constant中填入自己的APP_KEY, LOAD_URL和API_SERVER
3. 通过Web或者PC端创建一个房间
4. 运行工程，在房间号填写页面填写创建号的房间号
5. 点击加入房间，注册并登陆IM，然后进入白板页面并打开白板
