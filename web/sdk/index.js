const params = window.whiteboardParams

const whiteboardSDK = WhiteBoardSDK.getInstance({
    appKey: params.appKey,
    /**
     * 账号。目前白板信令基于IM账号。
     */
    account: params.account,
    token: params.token,
    /**
     * 白板容器。白板会撑满容器
     */
    container: document.getElementById('whiteboard'),
    /**
     * 白板应用的客户端。
     */
    platform: 'web',
    record: params.record
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
            platform: 'web',
            containerOptions: window.toolCollectionConfig
        }
    })
    
    toolCollection.show()
})