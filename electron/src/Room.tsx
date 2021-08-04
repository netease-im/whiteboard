import React from "react";
import sha1 from 'sha1';

import store from "./store";
import { insertScript } from "./util";

import './Room.less'

declare global {
    interface Window {
        WhiteBoardSDK: any
        ToolCollection: any
        drawPlugin: any
    }
}

export default class Room extends React.Component {
    whiteboardSDK: any
    toolCollection: any

    state = {
        cid: ''
    }

    componentDidMount() {
        const {appkey, uid, appsecret, whiteboard_sdk_url, toolcollection_sdk_url, channel} = store
        if (!(appkey && uid && appsecret && whiteboard_sdk_url && toolcollection_sdk_url && channel)) {
            return (this.props as any).history.push('/')
        }

        return Promise.all([insertScript(whiteboard_sdk_url as string), insertScript(toolcollection_sdk_url as string)])
            .then(_ => {
                this.whiteboardSDK = (window.WhiteBoardSDK as any).getInstance({
                    appKey: appkey,
                    uid: uid,
                    nickname: uid.toString(),
                    container: document.getElementById('whiteboard') as HTMLDivElement,
                    platform: 'pc',
                    record: true,
                    debug: true,
                    getAuthInfo: getAuthInfo
                })

                this.whiteboardSDK.joinRoom({
                    channel: channel,
                    createRoom: true
                }, {
                    onwillreconnect: () => {
                        this.setState({
                            roomState: '正在重连',
                            joinError: ''
                        })
                    },
                    ondisconnected: (err) => {
                        this.whiteboardSDK = undefined
                        if (this.toolCollection) {
                            this.toolCollection.destroy()
                        }
                    },
                    onconnected: () => {
                        (window.WhiteBoardSDK).hideToast()
                        this.setState({
                            roomState: '已连接',
                            joinError: ''
                        })
                    }
                })
                    .then((app: any) => {
                        this.setState({
                            cid: this.whiteboardSDK.getChannelId()
                        })
                        app.enableDraw(true)
                        app.setColor('rgb(243,0,0)')
                        window.drawPlugin = app
    
                        const toolCollection = (window.ToolCollection).getInstance({
                            container: document.getElementById('whiteboard') as HTMLDivElement,
                            handler: app,
                            options: {
                                platform: 'pc',
                                debug: true
                            }
                        })

                        toolCollection.addOrSetTool({
                            position: 'left',
                            item: {
                                tool: 'video'
                            },
                            insertAfterTool: 'opacity'
                        })

                        toolCollection.addOrSetTool({
                            position: 'left',
                            item: {
                                tool: 'audio'
                            },
                            insertAfterTool: 'opacity'
                        })

                        toolCollection.show()
                    })
            })
    }

    componentWillUnmount() {
        if (this.whiteboardSDK) {
            this.whiteboardSDK.destroy();
            (window.WhiteBoardSDK as any).hideToast();
        }
    }

    handleGotoConfig = () => {
        (this.props as any).history.push('/')
    }

    render() {
        return (
            <div>
                <div id='whiteboard'/>
                <div className='header'>
                    <button className='room-back-btn' onClick={this.handleGotoConfig}>配置页面</button>
                    <span>房间名称: {store.channel}</span>
                    <span>uid: {store.uid}</span>
                    <span>cid: {this.state.cid}</span>
                </div>
            </div>
        )
    }
}

/**
 * 模拟从应用服务器获取auth的过程
 */
function getAuthInfo() {
    const {appsecret} = store

    const Nonce = 'random-nonce-value'
    const curTime = Math.round((Date.now() / 1000))
    const checksum = sha1(appsecret + Nonce + curTime)
    return Promise.resolve({
        nonce: Nonce,
        checksum: checksum,
        curTime: curTime
    })
}