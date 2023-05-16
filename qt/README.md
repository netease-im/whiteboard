# 云信互动白板QT Demo

## 运行源代码

### 环境
* vs2019 
* Qt5.15.0

### 编译
* 用vs2019或者Qt5.15.0打开文件中whiteboard-sample.pro，并将编译器设置为win32。因为该程序中的glog为x86版本。
* 编译后会生成对应的.exe文件。此时会报缺少glogd.dll，则拷贝glog文件bin目录下的动态库置.exe文件中

## 注意
1. login/nem_login_manager.h中的密钥仅用于跑通sample code。请开发者及时替换为自己应用的appKey和appSecret。Sample Code中默认的参数会有一些使用限制
2. login/nem_login_manager.h中的m_staticUrl始终指向线上最新版本webview地址。为了保证您线上的应用不会由于版本升级失效，请到该地址：https://doc.yunxin.163.com/whiteboard/docs/DMzNDkxMDc?platform=web ，下载最新的webview静态资源，并通过您的静态服务器部署。

## 鉴权
本应用将鉴权过程放到了客户端。鉴权的函数在NEMWhiteboard.qml文件中实现。为了您的应用安全，请不要在客户端存储您的密钥。您可以改造NEMWhiteboard.qml，使其通过https请求，向您的业务服务器请求鉴权参数完成鉴权。