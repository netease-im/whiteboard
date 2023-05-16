## 云信互动白板 Electron Demo

该项目使用 `webpack` 打包，使用 `react` 作为前端框架。简单展示了如何使用 `electron` 创建一个白板应用。

## 示例项目结构
- src/assets: 图标资源以及 css 样式文件
- src/component: 公共组件
- src/pages: 登陆页面以及白板页面
- src/util: 帮助函数

## 快速运行
1. 下载本仓库后，在 electron 文件夹下打开控制台
2. 运行 `npm install` 安装依赖
3. 运行 `npm run start` 在本地启动 electron 开发预览窗口
## 调试脚本
```sh
1. npm install
2. npm start
3. 另开一个terminal，启动: npm run watch:dev
```
## 构建应用
```sh
1. npm install
2. npm run build:win
3. npm run build:mac
```
## 注意
1. src/env.ts 中的密钥仅用于 Sample Code 的运行。请开发者及时替换为自己应用的 appKey 和 appSecret。Sample Code 中默认的参数会有一些限制。
2. src/env.ts 中的 presetId 用于提供音视频上传后的转码功能。该能力可以增加音视频文件在各客户端的兼容性。请参考：https://doc.yunxin.163.com/whiteboard/docs/jU0OTEzODY?platform=web ，为您的应用申请转码模板。如果您的应用不需要在白板中上传并转码音视频，则需要提供该参数。
3. index.html 中的 SDK 脚本链接始终指向最新的 SDK 版本。为了保证您线上的应用不会由于版本升级失效，请按照文件中注释代码，下载最新的SDK脚本，并通过您的静态服务器部署。
## 鉴权
本示例代码将鉴权过程放到了客户端。鉴权的函数在 src/util/getAuthInfo.ts 文件中实现。为了您的应用安全，请不要在客户端存储您的密钥。您可以改造 src/util/getAuthInfo.ts 函数，使其通过https 请求，向您的业务服务器请求鉴权参数完成鉴权。下面是示例代码:
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