import React from "react";
import './Config.less'
import store from "./store";

export default class Config extends React.Component {
    state: any = {}

    componentDidMount() {
        const appkey = localStorage.getItem('appkey') ? localStorage.getItem('appkey') : ''
        const uid = localStorage.getItem('uid') ? localStorage.getItem('uid') : ''
        const whitebaord_sdk_url = localStorage.getItem('whitebaord_sdk_url') ? 
            localStorage.getItem('whitebaord_sdk_url') : 'https://app.yunxin.163.com/webdemo/whiteboard/stable/3.3.0/sdk/WhiteBoardSDK_v3.3.0.js'
        const toolcollection_sdk_url = localStorage.getItem('toolcollection_sdk_url') ? 
            localStorage.getItem('toolcollection_sdk_url') : 'https://app.yunxin.163.com/webdemo/whiteboard/stable/3.3.0/sdk/ToolCollection_v3.3.0.js'
        const appsecret = localStorage.getItem('appsecret') ? localStorage.getItem('appsecret') : ''
        this.setState({
            appkey,
            whitebaord_sdk_url,
            toolcollection_sdk_url,
            appsecret,
            uid
        })
    }

    handleAttrChange = (ev, attrName) => {
        this.setState({
            [attrName]: ev.target.value
        })

        localStorage.setItem(attrName, ev.target.value)
    }

    handleEnterRoom = () => {
        const {appkey, appsecret, uid, channel, whitebaord_sdk_url, toolcollection_sdk_url} = this.state

        if (!appkey) {
            alert('必须提供appkey')
        } else if (!appsecret) {
            alert('必须提供appsecret')
        } else if (!uid) {
            alert('必须提供uid')
        } else if (!channel) {
            alert('必须提供channel')
        } else {
            store.appsecret = appsecret
            store.appkey = appkey
            store.uid = uid
            store.channel = channel
            store.whiteboard_sdk_url = whitebaord_sdk_url
            store.toolcollection_sdk_url = toolcollection_sdk_url

            const props = this.props as any
            props.history.push('/room');
        }
    }

    render() {
        return (
            <div className='config-container'>
                {this.renderField('uid', 'uid', 'number')}
                {this.renderField('房间号', 'channel')}
                {this.renderField('appkey', 'appkey')}
                {this.renderField('app secret', 'appsecret')}
                {this.renderField('whiteboardSDK地址', 'whitebaord_sdk_url')}
                {this.renderField('toolCollection地址', 'toolcollection_sdk_url')}
                <div>
                    <div className='label'></div>
                    <button onClick={this.handleEnterRoom}>进入房间</button>
                </div>
            </div>
          );
    }

    renderField(label, attrName, type='text') {
        return (
            <div>
                <div className='label'>{label}:</div>
                <input type={type} value={this.state[attrName]} onChange={(ev) => this.handleAttrChange(ev, attrName)}></input>
            </div>
        )
    }
}