var nim, nimWB, toolbar, drawPlugin, pageControl

const params = window.whiteboardParams

/**
 * **********************************************************************
 * ************************创建信令 + 创建/加入房间  ***********************
 * **********************************************************************
 */

nim = NIM.getInstance({
    db: false,				//是否开启数据库服务。白板应用中不需要，设置为false
    debug: params.debug,		//开发时设置为true
    appKey: params.appKey,		
    account: params.account,	//IM账号
    token: params.token,			//MD5加密后的IM密码
  	onconnect: function() {
          //下一步应该WhiteBoard.getInstance, 建议白板信令连接
          nimWB = WhiteBoard.getInstance({
              nim: nim,
              debug: params.debug
          })
          joinChannel()
    },
    ondisconnect: function() {
        //断开白板信令，销毁白板
    },
    onerror: function() {
        //断开白板信令，销毁白板
        nimWB.leaveChannel()
        toolbar.destroy()
        drawPlugin.destroy()
        pageControl.destroy()
    }
})

/**
 * 加入或者创建房间
 */
function joinChannel() {
    return nimWB.joinChannel({
        channelName: params.channelName,
        sessionConfig: {
          record: params.record
        }
      }).then(() => {
        nimWB.startSession().then(function () {
          initWhiteBoard()
        })
      }).catch((err) => {
        if (err && err.event && err.event.code === 404 && params.account === params.ownerAccount) { 
          //频道未创建, 下面创建频道
          return createChannel()
        }
        //其他情况，出错了
    })
}

function createChannel() {
    return nimWB.createChannel({
        channelName: param.channelName
    }).then((obj) => {
        return joinChannel(param)
    }).catch((err) => {
        if (err && err.event && err.event.code === 417) { // 已创建房间
          joinChannel(param)
        }
        //其他情况，出错了
    })
}



/**
 * **********************************************************************
 * *****************************  绘制流程  ******************************
 * **********************************************************************
 */

function initWhiteBoard() {
    drawPlugin = DrawPlugin.getInstance({
        /**
         * 账号。目前白板信令基于IM账号。
         */
        account: params.account,
        /**
         * 预留字段
         */
        nickname: params.nickname,
        /**
         * 房间拥有者账号, 也是IM账号
         */
        ownerAccount: params.ownerAccount,
        /**
         * 白板信令连接，即上文中的nim_WB
         */
        connector: nimWB,
        /**
         * 白板容器。白板会撑满容器
         */
        container: document.getElementById('whiteboard'),
        /**
         * 白板房间号
         */
        channel: params.channelName,
        /**
         * 白板应用的客户端。
         */
        platform: 'web'
    })

    toolbar = Toolbar.getInstance({
        /**
         * 工具栏容器
         * 
         * 该容器应该和白板容器是同一个
         */
        container: document.getElementById('whiteboard'),
    
        /**
         * drawPlugin对象
         */
        handler: drawPlugin,
    
        options: {
            /**
             * 工具栏位置
             */
            position: 'left',
            /**
             * SDK根据不同平台定制了部分UI样式
             */
            platform: 'web'
        }
    })

    pageControl = PageControl.getInstance({
        /**
         * 工具栏容器
         * 
         * 该容器应该和白板容器是同一个
         */
        container: document.getElementById('whiteboard'),
    
        /**
         * drawPlugin对象
         */
        handler: drawPlugin,
    
        options: {
            /**
             * SDK根据不同平台定制了页码显示方式，以及是否支持切换页码
             * 目前pc，web，mac，pad支持切换页码，显示在右下角
             * android，ios不支持切换，显示在左下角
             *
             * 用户可以自己适配css文件调整样式
             */
            platform: 'web'
        }
    })

    drawPlugin.enableDraw(true)
    toolbar.setDefaultColor('rgb(254,100,121)')
    toolbar.show()
    pageControl.show()
    drawPlugin.readyToSyncData()
}