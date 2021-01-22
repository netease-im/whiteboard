## 目录结构

-- webview                  //webview接入示例
    -- webview              //白板webview页面。用户应该将其部署到自己的静态服务器中
        -- sdk
            -- NIM_Web_NIM
            -- NIM_Web_WhiteBoard
            -- DrawPlugin
            -- PageControl
            -- Toolbar
            -- vconsole
            -- webview
        -- css
            -- webview.css          
        -- webview.html     //用户客户端应该接入此html
        -- webview.log.html //带日志的webview.html, 开发/调试阶段使用

    -- index.html           //模拟客户端接入白板webview的示例
    -- index.iframe.html    //使用iframe接入白板webview的示例

-- sdk                      //sdk接入示例
    -- sdk                  //sdk文件目录
        -- NIM_Web_NIM
        -- NIM_Web_WhiteBoard
        -- DrawPlugin
        -- PageControl
        -- Toolbar

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