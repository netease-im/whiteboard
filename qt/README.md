## 如何编译

### 环境
* vs2019 
* Qt5.15.0

### appkey及appsecret配置
* 打开login文件夹中的nem_login_manager.h。
* 令QString m_appKey = 给定appKey。
* 令QString m_appsecret = 给定appsecret。

### 编译
* 用vs2019或者Qt5.15.0打开文件中whiteboard-sample.pro，并将编译器设置为win32。因为该程序中的glog为x86版本。
* 编译后会生成对应的.exe文件。此时会报缺少glogd.dll，则拷贝glog文件bin目录下的动态库置.exe文件中
