# 云信互动白板Android Demo

## 项目主要文件

```md
com.netease.whiteboardandroiddemo.main.MainActivity.java //房间号填写页面
com.netease.whiteboardandroiddemo.whiteboard.WhiteboardActivity.java // 白板页面
com.netease.whiteboardandroiddemo.whiteboard.WhiteboardJsInterface.java // 白板JsBridge定义页面
com.netease.whiteboardandroiddemo.Constant // 存放常量，运行工程需要在此填入APP_KEY, WEBVIEW_URL, CHECKSUM_URL, WS_SECRET_URL, PRESET_ID
```
## 运行源代码

1. 下载本仓库后，通过Android Studio打开本项目，等待下载依赖
2. 进入 com.netease.whiteboardandroiddemo.Constant，修改 APP_KEY, WEBVIEW_URL, CHECKSUM_URL, WS_SECRET_URL, PRESET_ID
2. 构建并运行本项目
## 日志获取
当白板无法正常使用时，可查看weblog相关信息定位出错原因，日志默认路径位于：
/data/data/com.netease.whiteboardandroiddemo/files/weblog/ne_whiteboard_xxxxxxx.log

## 配置说明

### WEBVIEW_URL
请到该地址：https://doc.yunxin.163.com/whiteboard/docs/DMzNDkxMDc?platform=web ，下载最新的webview静态资源，并通过您的静态服务器部署。

### CHECKSUM_URL
checksum鉴权规则说明：https://doc.yunxin.163.com/whiteboard/docs/DQ4Nzc5Mjc?platform=server

客户的应用服务器地址。该服务器地址主要有两个功能：
1. 根据 appkey, appsecret, curtime, nonce 生成白板鉴权参数 checksum
2. 获取防盗链参数

进入房间前，demo 应用会向该地址：`${CHECKSUM_URL}` 发送 POST 请求。

请求参数如下，请求格式为: `application/json`
```js
{
    roomId: 'roomId',
    uid: '23213',
    wbAppKey: '用户的 APPKEY'
}
```

客户的应用服务器计算 checksum 后，应该返回下列格式的结果:
```js
{
    code: 200,
    data: {
        wbAppKey: '用户的 APPKEY',
        wbCheckSum: '鉴权 checksum',
        wbCurtime: 'checksum生成时使用的时间戳。该时间戳为秒级',
        wbNonce: 'checksum生成时使用的128位以下随机数'
    }
}
```

#### WS_SECRET_URL
防盗链计算规则: https://doc.yunxin.163.com/vod/docs/DM5MzI2OTI?platform=server#%E9%89%B4%E6%9D%83%E5%AD%97%E7%AC%A6%E4%B8%B2%E7%9A%84%E8%AE%A1%E7%AE%97%E8%A7%84%E5%88%99

若设置了点播开启 URL鉴权 防盗链，则应用服务器需要帮忙计算资源的防盗链 URL。具体来说，在请求防盗链资源时，白板会向应用服务器地址： `${WS_SECRET_URL}` 发送 POST 请求。

请求的参数为: 
```js
{
    bucketName: '资源桶名',
    objectKey: '资源object名',
    wbAppKey: '用户的 APPKEY',
    wsTime: '秒级时间戳'
}
```

用户的应用服务器应该根据上述信息，计算防盗链参数 wsSecret，并返回给白板。返回的参数格式应该为: 
```js
{
    code: 200,
    data: {
        wsSecret: '根据规则计算的防盗链参数'
    }
}
```

### PRESET_ID
转码模板 ID。向白板中上传音视频时，如果传入的音视频编码格式、容器格式兼容性不好，可能导致音视频在一些客户端无法播放。因此，我们推荐根据文档：https://doc.yunxin.163.com/whiteboard/docs/jU0OTEzODY?platform=web，创建转码模板，生成兼容性较好的音视频插入到白板中。

生成模板后，在 Constant 文件中替换 PRESET_ID 即可。

## 应用服务器说明
上述的请求参数，以及响应结果都是 demo 层的一个配置。用户如果应用服务器有不同的参数风格偏好，可以修改 demo 中对应的参数。