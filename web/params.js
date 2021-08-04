function getParams() {
    /**
     * uid                任意正整数。同一uid同时登录时会互踢
     * channel:           随机字符串。同一房间内用户可以相互同步
     * appKey:            请联系网易云信销售团队获取appKey
     * appSecret:         appKey对应的密钥
     * platform:          'android' | 'ios' | 'pc' | 'mac' | 'pad', 根据platform不同适配了工具栏和部分UI, 'web'接入可以先填'pc'
     * record:            是否开启录制
     * debug:             开发模式下开启
     */
    const uid = Math.round(Math.random() * 10000000000)
    const channel = '132222123'
    const appKey = 'caee83f25bef456b13b4e9f54c8da4c8'
    const appSecret = 'c45c1fa7999e'
    const platform = 'web'
    const record = true
    const debug = true

    return {
        uid, channel, appKey, appSecret, platform, record, debug
    }
}

window.whiteboardParams = getParams()