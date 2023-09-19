本开源项目主要展示互动白板 iOS 端如何快速集成互动白板 WebView 接入方案，帮助开发者实现互动白板能力。

> Note：github 上有大小写不敏感问题，同一目录下不要有两个大小写相同的文件夹，example: iOS、ios

sample code 仅作为展示使用。实际开发时，请不要将 app secret 放置在客户端代码中，以防泄漏。sample code 中放置 app secret 是为了开发者在没有设置应用服务器的情况下，即能够跑通白板的流程。

sample code 的启动流程如下：  
1. 进入目录 ios/WhiteBoardWebDemo/，打开WhiteBoardWebDemo.xcworkspace 
2. 设置 WhiteBoardWebDemo/NMCWhiteBoard/NMCWhiteBoardConfig.h 中的配置
3. 在项目配置中选择 Signing & Capabilities，配置 team、bundle identifier 和 provisioning profile 等信息  
4. 选择设备（真机或模拟器），点击 “run” 即可

## 配置说明

### kServerDomain
客户的应用服务器地址。该服务器地址主要有两个功能：
1. 根据 appkey, appsecret, curtime, nonce 生成白板鉴权参数 checksum
2. 获取防盗链参数

#### checksum鉴权
checksum鉴权规则说明：https://doc.yunxin.163.com/whiteboard/docs/DQ4Nzc5Mjc?platform=server

用户填入 kServerDomain 后，iOS demo 应用会向该地址：`${kServerDomain}/wb/getCheckSum` 发送 POST 请求。

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

#### 防盗链参数
防盗链计算规则: https://doc.yunxin.163.com/vod/docs/DM5MzI2OTI?platform=server#%E9%89%B4%E6%9D%83%E5%AD%97%E7%AC%A6%E4%B8%B2%E7%9A%84%E8%AE%A1%E7%AE%97%E8%A7%84%E5%88%99

若设置了点播开启 URL鉴权 防盗链，则应用服务器需要帮忙计算资源的防盗链 URL。具体来说，在请求防盗链资源时，白板会向应用服务器地址： `${kServerDomain}/wb/getWsSecret` 发送 POST 请求。

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

### kPresetId
转码模板 ID。向白板中上传音视频时，如果传入的音视频编码格式、容器格式兼容性不好，可能导致音视频在一些客户端无法播放。因此，我们推荐根据文档：https://doc.yunxin.163.com/whiteboard/docs/jU0OTEzODY?platform=web，创建转码模板，生成兼容性较好的音视频插入到白板中。

生成模板后，在 ios 文件中替换 kPresetId 即可。

## 应用服务器说明
上述的请求参数，以及响应结果都是 demo 层的一个配置。用户如果应用服务器有不同的参数风格偏好，可以修改 demo 中对应的参数。