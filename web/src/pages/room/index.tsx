import React, { useEffect, useState } from "react";
import env from '../../env'
import getAuthInfo from '../../util/getAuthInfo'
import Alert from '../../component/alert'
import { NavigateFunction, useNavigate, useParams } from "react-router-dom"

declare global {
  interface Window {
    WhiteBoardSDK: any
    ToolCollection: any
  }
}

export default function Room(props) {
  const [whiteboardSDK, setWhiteBoardSDK] = useState(undefined)
  //退出房间的警告弹窗
  const [alert, setAlert] = useState(false)
  //随机生成uid
  const [uid] = useState(Math.ceil(Math.random() * 10000000))
  //使用history切换路由
  const history = useNavigate()
  //从URL地址中获取roomId
  const {roomId} = useParams()
  
  if (!roomId) {
    history('/')
  }

  /**
   * 进入该页面后，初始化whiteboardSDK，然后joinRoom
   */
  useEffect(() => {
    const whiteboardSDK = window.WhiteBoardSDK.getInstance({
      appKey: env.appKey,
      uid: uid,
      container: document.getElementById('whiteboard'),
      platform: 'web',
      record: true,
      getAuthInfo: () => { return getAuthInfo(env.appSecret) }
    })

    setWhiteBoardSDK(whiteboardSDK)
    joinRoom({
      whiteboardSDK,
      history,
      ondisconnected: () => history('/'),
      channel: roomId as string,
      container: document.getElementById('whiteboard') as HTMLDivElement,
      presetId: env.presetId
    })
  }, [])

  /**
   * 退出房间
   */
  function doExitRoom() {
    if (whiteboardSDK) {
      (whiteboardSDK as any).destroy()
    }
    history('/')
  }

  /**
   * 拷贝房间号到剪切板中
   */
  function handleCopyRoomId() {
    const textArea = document.createElement('textarea')
    textArea.id = 'textarea-used-for-copy-text'
    document.body.appendChild(textArea)
    textArea.value = roomId as string
    textArea.setAttribute('style', 'position: absolute; top: 0; left: 0;')
    textArea.focus()
    textArea.select()
    document.execCommand('copy')
    document.body.removeChild(textArea)
    window.WhiteBoardSDK.showToast({
      msg: `已复制房间号: ${roomId}`,
      time: 2,
      type: 'success'
    })
  }

  function renderHeader() {
    return (
      <div className="m-header">
        {roomId &&
          <div className="room-info">
            {'房间号'}: {roomId}
            <div className='room-info-copy' onClick={handleCopyRoomId} />
          </div>
        }
        <div className="opt">
          <span>用户ID: {uid}</span>
          <div className="opt-inner">
            <a
              className="logout"
              onClick={() => {
                setAlert(true)
              }}
            >
              离开房间
            </a>
          </div>
        </div>
      </div>
    );
  }

  /**
   * 确认退出房间弹窗警告
   */
  function renderAlert() {
    return (
      <Alert
        msg={<div className="u-logoutim"><i className="u-icon-tip"></i> {'确认要离开房间？'}</div>}
        btns={[
          {
            label: '退出',
            clsName: "u-btn-warning",
            onClick: () => {
              doExitRoom();
              setAlert(false)
            }
          },
          {
            label: '取消',
            clsName: "u-btn-cancle",
            onClick: () => {
              setAlert(false)
            }
          }
        ]}
      />
    )
  }

  return (
    <div id='room'>
      {renderHeader()}
      <div id='whiteboard' />
      {alert && renderAlert()
      }
    </div>
  )
}

function joinRoom(opt: {
  whiteboardSDK: any
  channel: string
  ondisconnected: Function
  presetId: number
  container: HTMLDivElement
  history: NavigateFunction
}) {
  const {whiteboardSDK, channel, ondisconnected, presetId, container, history} = opt
  debugger
    whiteboardSDK.joinRoom({
      channel: channel,
      createRoom: true
    }, {
      ondisconnected: () => {
        ondisconnected()
      }
    })
      .then((app) => {
        app.enableDraw(true)
        /**
         * 设置presetId。支持音视频上传并转码
         */
        app.setAppConfig({
          presetId: presetId
        })

        const toolCollection = window.ToolCollection.getInstance({
          container: container,
          handler: app,
          options: {
            platform: 'web'
          }
        })

        //显示工具栏
        toolCollection.show()

        /**
         * 根据目前是否是动态文档，切换页面工具栏的状态，可以为：
         * 1. 第一页，上一页，下一页，最后一页
         * 2. 上一页，上一动画，下一动画，下一页（动态文档)
         */
        let hasTransDoc = false
        app.on('event:appState:change', (name, value) => {
          if (name === 'board') {
            if (!hasTransDoc && app.hasTransDoc()) {
              hasTransDoc = true
              toolCollection.addOrSetContainer({
                position: 'bottomRight',
                items: [
                  {
                    tool: 'prevPage',
                    hint: '上一页',
                  },
                  {
                    tool: 'prevAnim',
                    hint: '上一动画'
                  },
                  {
                    tool: 'pageInfo'
                  },
                  {
                    tool: 'nextAnim',
                    hint: '下一动画'
                  },
                  {
                    tool: 'nextPage',
                    hint: '下一页'
                  },
                  {
                    tool: 'preview',
                    hint:  '预览',
                    previewSliderPosition: 'right'
                  }
                ]
              })
            } else if (hasTransDoc && !app.hasTransDoc()) {
              hasTransDoc = false
              toolCollection.addOrSetContainer({
                position: 'bottomRight',
                items: [
                  {
                    tool: 'firstPage',
                    hint: '第一页',
                  },
                  {
                    tool: 'prevPage',
                    hint: '上一页',
                  },
                  {
                    tool: 'pageInfo'
                  },
                  {
                    tool: 'nextPage',
                    hint: '下一页',
                  },
                  {
                    tool: 'lastPage',
                    hint: '最后一页',
                  },
                  {
                    tool: 'preview',
                    hint: '预览',
                    previewSliderPosition: 'right'
                  }
                ]
              })
            }
          }
        })
      })
      .catch(err => {
        console.error(err)
        history('/')
      })
}
