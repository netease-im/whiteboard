## 云信互动白板Web Demo

该项目使用`webpack`打包，使用`react`作为前端框架。该项目简单展示了如何启动一个白板应用。

## 项目目录结构
- src/assets: 图标资源以及css样式文件
- src/component: 公共组件
- src/pages: 登陆页面以及白板页面
- src/util: 帮助函数

## 运行源代码
1. 下载本仓库后，在web文件夹下打开控制台
2. 运行`npm install`安装依赖
3. 运行`npm run start`在本地启动静态服务

## 注意
1. src/env.ts中的密钥仅用于sample code跑通。请开发者及时替换为自己应用的appKey和appSecret。Sample Code中默认的参数会有一些限制。
2. src/env.ts中的presetId用于提供音视频上传后的转码功能。该能力可以增加音视频文件在各客户端的兼容性。请参考：https://doc.yunxin.163.com/whiteboard/docs/jU0OTEzODY?platform=web ，为您的应用申请转码模板。如果您的应用不需要在白板中上传并转码音视频，则需要提供该参数
3. index.html中的SDK脚本链接始终指向最新的SDK版本。为了保证您线上的应用不会由于版本升级失效，请按照文件中注释代码，下载最新的SDK脚本，并通过您的静态服务器部署


## 鉴权
本应用将鉴权过程放到了客户端。鉴权的函数在src/util/getAuthInfo.ts文件中实现。为了您的应用安全，请不要在客户端存储您的密钥。您可以改造src/util/getAuthInfo.ts函数，使其通过https请求，向您的业务服务器请求鉴权参数完成鉴权。下面是示例代码:
```js
function getAuthInfo(appsecret: string) {
    /**
     * getAuthInfo返回nonce, checksum和curtime
     * 
     * Nonce: 128位以下的随机字符串
     * curTime: 秒级时间戳
     * checksum: sha1(appsecret + Nonce + curTime)
     */
    return fetch('https://www.yourServerAddress.com/getAuthInfo')
        .then(res => res.json())
}

```