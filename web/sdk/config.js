function getParams() {
    /**
     * account:           网易云信IM账号
     * ownerAccount:      房间创建者IM账号。创建者的account和ownerAccount一样
     * nickname:          预留字段
     * token:             通过MD5加密的网易云信IM密码
     * 
     * channelName:
     * 1. 建议使用8-9位纯数字的房间号
     * 2. 每次教师创建时应该随机生成房间号
     * 3. 学生端加入时房间号应该和创建时的房间号一样
     * 4. 如果account和ownerAccount相同 && 房间号未创建，webview会创建该频道。否则会尝试加入该房间。
     * 
     * 
     * appKey:            请联系网易云信销售团队获取appKey
     * platform:          'android' | 'ios' | 'pc' | 'mac' | 'pad', 根据platform不同适配了工具栏和部分UI, 'web'接入可以先填'pc'
     * 
     * record:            是否开启录制
     * debug:             开发模式下开启
     */
    const account = ''
    const ownerAccount = ''
    const nickname = ''
    const token = ''   //md5(123456) ===> e10adc3949ba59abbe56e057f20f883e
    const channelName = ''
    const appKey = ''
    const platform = ''
    const record = true
    const debug = true

    return {
        account, ownerAccount, nickname, token, channelName, appKey, platform, record, debug
    }
}

window.whiteboardParams = getParams()