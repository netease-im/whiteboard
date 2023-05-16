import sha1 from './sha1'

/**
 * 通过appsecret生成鉴权信息。白板服务器将使用下面函数返回的结果做权限校验。
 * 
 * 开发者应该通过服务器生成鉴权参数，并使用网络请求获取鉴权结果。若在客户端中写入了appsecret，则存在密钥被盗用的风险。
 */
function getAuthInfo(appsecret: string) {
    const Nonce = 'xxxxx'
    const curTime = Math.round((Date.now() / 1000))
    const checksum = sha1(appsecret + Nonce + curTime)
    return Promise.resolve({
        nonce: Nonce,
        checksum: checksum,
        curTime: curTime
    })
}

export default getAuthInfo