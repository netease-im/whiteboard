## 云信互动白板 Electron Demo

该项目使用 `webpack` 打包，使用 `react` 作为前端框架。简单展示了如何使用 `electron` 创建一个白板应用。

## 示例项目结构
- src/assets: 图标资源以及 css 样式文件
- src/component: 公共组件
- src/pages: 登陆页面以及白板页面
- src/env.ts: 环境变量。在启动应用前，你需要修改该文件。请参考【注意】

## 快速运行
1. 下载本仓库后，在 electron 文件夹下打开控制台
2. 运行 `npm install` 安装依赖
3. 参考【注意】, 替换 appkey，鉴权函数，以及防盗链函数等
4. 运行 `npm run start` 在本地启动 electron 开发预览窗口
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
1. 替换 src/env.ts 中的 APPKEY 为你的应用 APPKEY
2. src/env.ts 需要 完成 getAuthInfo 函数才可以登录。你应该连接到你的应用服务器，获取登录的鉴权信息。鉴权参数的示例文档请参考：https://doc.yunxin.163.com/whiteboard/docs/DQ4Nzc5Mjc?platform=server
3. 如果你需要开启防盗链功能，则需要完成 src/env.ts 中的 getAntiLeechInfo 函数。该函数从你的应用服务器获取资源的防盗链参数。获取防盗链参数的示例文档请参考：https://doc.yunxin.163.com/vod/docs/DM5MzI2OTI?platform=server#URL%20%E9%89%B4%E6%9D%83%E7%9A%84%E5%8A%9F%E8%83%BD%E5%8E%9F%E7%90%86
4. src/env.ts 中的 presetId 用于提供音视频上传后的转码功能。该能力可以增加音视频文件在各客户端的兼容性。请参考：https://doc.yunxin.163.com/whiteboard/docs/jU0OTEzODY?platform=web ，为您的应用申请转码模板。如果您的应用需要在白板中上传并转码音视频，则需要提供该参数。
5. index.html 中的 SDK 脚本链接始终指向最新的 SDK 版本。为了保证您线上的应用不会由于版本升级失效，请从该地址：https://doc.yunxin.163.com/whiteboard/docs/DMzNDkxMDc?platform=web，下载最新的SDK脚本，并通过您的静态服务器部署。
