# 云信互动白板Android Demo

## 项目主要文件

```md
com.netease.whiteboardandroiddemo.main.MainActivity.java //房间号填写页面
com.netease.whiteboardandroiddemo.whiteboard.WhiteboardActivity.java // 白板页面
com.netease.whiteboardandroiddemo.whiteboard.WhiteboardJsInterface.java // 白板JsBridge定义页面
com.netease.whiteboardandroiddemo.Constant // 存放常量，运行工程需要在此填入APP_KEY, APP_SECRET和WEBVIEW_URL
```

## 运行源代码

1. 下载本仓库后，通过Android Studio打开本项目，等待下载依赖
2. 构建并运行本项目

## 注意
1. com.netease.whiteboardandroiddemo.Constant 中的密钥仅用于sample code跑通。请开发者及时替换为自己应用的appKey和appSecret。Sample Code中默认的参数会有一些限制。
2. com.netease.whiteboardandroiddemo.Constant中的WEBVIEW_URL始终指向最新的SDK版本。为了保证您线上的应用不会由于版本升级失效，请到该地址：https://doc.yunxin.163.com/whiteboard/docs/DMzNDkxMDc?platform=web ，下载最新的webview静态资源，并通过您的静态服务器部署。

## 鉴权
本应用将鉴权过程放到了客户端。鉴权的函数在com.netease.whiteboardandroiddemo.whiteboard.WhiteboardJsInterface.java文件中实现。

为了您的应用安全，请不要在客户端存储您的密钥。您可以改造com.netease.whiteboardandroiddemo.whiteboard.WhiteboardJsInterface.java文件的sendAuthInfo函数，使其通过https请求，向您的业务服务器请求鉴权参数完成鉴权。

## 日志获取
当白板无法正常使用时，可查看weblog相关信息定位出错原因，日志默认路径位于：
/data/data/com.netease.whiteboardandroiddemo/files/weblog/ne_whiteboard_xxxxxxx.log
