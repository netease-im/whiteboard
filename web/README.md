本开源项目主要展示互动白板 Web 端如何快速集成互动白板 SDK 和 WebView 接入方案，帮助开发者实现互动白板能力。

## 目录结构

```md
-- webview                  //webview接入示例   
    -- webview              //白板webview页面。用户应该将其部署到自己的静态服务器中   
    -- index.html           //webview sample code入口文件

-- sdk                      //sdk接入示例
    -- sdk                  //sdk文件目录
    -- index.html           //sdk sample code入口文件
```

## webview示例

```bash
1. cd webview
2. 修改config.js, 在`getParams`函数中填入必要参数
3. 开启静态服务器，例如：`npx serve ./`
```

## sdk接入示例

sdk接入适合于需要定制化部分功能，UI的用户。sdk接入时，需要用户自行处理文档转码相关逻辑

```bash
1. cd sdk
2. 修改config.js, 在`getParams`函数中填入必要参数
3. 开启静态服务器，例如：`npx serve ./`
```
