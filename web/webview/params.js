function getParams() {
    /**
     * account:           网易云信IM账号
     * token:             通过MD5加密的网易云信IM密码
     * pwd:               开发阶段可以使用pwd传输明文密码。生产环境下请替换为MD5加密密码
     * 
     * channelName:       学生端加入时房间号应该和创建时的房间号一样
     * 
     * 
     * appKey:            请联系网易云信销售团队获取appKey
     * platform:          'android' | 'ios' | 'pc' | 'mac' | 'pad', 根据platform不同适配了工具栏和部分UI, 'web'接入可以先填'pc'
     * 
     * record:            是否开启录制
     * debug:             开发模式下开启
     */
    const account = ''
    const pwd = ''
    const token = ''  //  md5(123456) ===> e10adc3949ba59abbe56e057f20f883e
    const channelName = ''
    const appKey = ''
    const platform = ''
    const record = true
    const debug = true

    return {
        account, pwd, token, channelName, appKey, platform, record, debug
    }
}

window.whiteboardParams = getParams()