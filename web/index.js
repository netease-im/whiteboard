const params = window.whiteboardParams

const whiteboardSDK = WhiteBoardSDK.getInstance({
    appKey: params.appKey,
    uid: params.uid,
    /**
     * 白板容器。白板会撑满容器
     */
    container: document.getElementById('whiteboard'),
    /**
     * 白板应用的客户端。
     */
    platform: 'web',
    record: params.record,
    getAuthInfo: getAuthInfo
})


whiteboardSDK.joinRoom({
    channel: params.channel,
    createRoom: true
}, {
    ondisconnected: (err) => {
        console.error(err)
        /**
         * toast的classname是：whiteboard-toast
         */
        WhiteBoardSDK.showToast({
            msg: '连接已断开',
            type: 'error',
            time: 3
        })
    }
})
.then((drawPlugin) => {
    drawPlugin.enableDraw(true)
    drawPlugin.setColor('rgb(243,0,0)')

    const toolCollection = ToolCollection.getInstance({
        container: document.getElementById('whiteboard'),
        handler: drawPlugin,
        options: {
            platform: params.platform,
        }
    })

    toolCollection.addOrSetTool({
        position: 'left',
        item: {
            tool: 'video'
        }
    })

    toolCollection.addOrSetTool({
        position: 'left',
        item: {
            tool: 'audio'
        }
    })
    
    toolCollection.show()
})

/**
 * 请注意！！！！：
 * SampleCode仅为演示用。实际开发时，请不要将appSerect存在客户端中。
 * 实际开发中，下面函数应该从服务器中获取auth并返回给webview
 */
function getAuthInfo() {
    const Nonce = 'xxxx'    //随机长度小于128位的字符串
    const curTime = Math.round((Date.now() / 1000))
    const checksum = sha1(params.appSecret + Nonce + curTime)
    return Promise.resolve({
        nonce: Nonce,
        checksum: checksum,
        curTime: curTime
    })
}