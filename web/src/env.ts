const GET_AUTH_ADDRESS = 'GET_AUTH_ADDRESS'
const GET_ANTI_LEECH_ADDRESS = 'GET_ANTI_LEECH_ADDRESS'

/**
 * 从应用服务器获取鉴权信息
 */
function getAuthInfo(appkey, roomId, uid) {
    return fetch(GET_AUTH_ADDRESS, {
        method: 'post',
        headers: {
            'content-type': 'application/json'
        },
        body: JSON.stringify({
            wbAppKey: appkey,
            roomId,
            uid
        })
    })
        .then(res => {
            return res.json()
        })
        .then(res => {
            if (res.code === 200) {
                return {
                    nonce: res.data.wbNonce,
                    checksum: res.data.wbCheckSum,
                    curTime: res.data.wbCurtime
                }
            } else {
                throw res
            }
        })
        .catch(err => {
            console.error('getWbAuth Error', err)
            throw err
        })
}

/**
 * 从应用服务器获取防盗链参数。若未开启防盗链，则不需要提供该接口
 */
function getAntiLeechInfo(prop, url, appkey) {
    const wsTime = Math.ceil((Date.now() / 1000))
    return fetch(GET_ANTI_LEECH_ADDRESS, {
        method: 'post',
        headers: {
            'content-type': 'application/json'
        },
        body: JSON.stringify({
            wbAppKey: appkey,
            bucketName: prop.bucket,
            objectKey: prop.object,
            wsTime: wsTime.toString()
        })
    })
        .then(res => {
            return res.json()
        })
        .then(res => {
            if (res.code === 200) {
                return {
                    url: `${url}?wsSecret=${res.data.wsSecret}&wsTime=${wsTime}`
                }
            } else {
                throw res
            }
        })
        .catch(err => {
            console.error('getAntiLeechInfo Error', err)
            throw err
        })
}

/**
 * presetId: 请参考这篇文档生成presetId。https://doc.yunxin.163.com/whiteboard/docs/jU0OTEzODY?platform=web。如果不填presetId，则无法使用音视频上传并转码的功能。
 * 
 * 请将appkey替换成您应用的appKey
 */
export default {
    "appKey":"YOUR_APPKEY",
    "presetId":"YOUR_PRESET_ID",
    getAuthInfo: getAuthInfo,
    getAntiLeechInfo: getAntiLeechInfo
}