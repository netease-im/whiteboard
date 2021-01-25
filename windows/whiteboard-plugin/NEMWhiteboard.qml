import QtQuick 2.6
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtWebChannel 1.0
import QtWebEngine 1.1
import NEMWhiteboard 1.0

Item {
    id: root
    visible: true

    property string whiteboardUrl: ""
    property string whiteboardAccount: ""
    property string whiteboardOwnerAccount: ""
    property string whiteboardToken: ""
    property string whiteboardChannelName: ""
    property string whiteboardAppKey: ""
    property bool whiteboardRecord: false
    property bool whiteboardDebug: false

    signal createWriteBoardSucceed()
    signal createWriteBoardFailed(string errorMessage)
    signal joinWriteBoardSucceed()
    signal joinWriteBoardFailed(string errorMessage)
    signal leaveWriteBoard()
    signal writeBoardError(string errorMessage)
    signal loginIMSucceed()
    signal loginIMFailed(string errorMessage)

    NEMJsBridge {
        id: jsBridge
        WebChannel.id: "qJsBridge"

        onWebPageLoadFinished: {
            loginWhiteboard()
            enableDraw()
            setWhiteboardColor()
        }

        onWebCreateWriteBoardSucceed: {
            createWriteBoardSucceed()
        }

        onWebCreateWriteBoardFailed: {
            createWriteBoardFailed(errorMessage)
        }

        onWebJoinWriteBoardSucceed: {
            joinWriteBoardSucceed()
        }

        onWebJoinWriteBoardFailed: {
            joinWriteBoardFailed(errorMessage)
        }

        onWebLeaveWriteBoard: {
            leaveWriteBoard()
        }

        onWebError: {
            writeBoardError(errorMessage)
        }

        onWebLoginIMSucceed: {
            loginIMSucceed()
        }

        onWebLoginIMFailed: {
            loginIMFailed(errorMessage)
        }

        onWebJsError: {
            writeBoardError(errorMessage)
        }
    }

    WebEngineView {
        id: webview
        anchors.fill: parent
        url: whiteboardUrl
        webChannel: channel
    }

    WebChannel {
        id: channel
        registeredObjects: [jsBridge]
    }

    function sendMessageToWeb(jsonParam){
        var strParam = JSON.stringify(jsonParam)
        var webScript = "WebJSBridge(" + strParam + ");"
        console.log("webScript", webScript)
        webview.runJavaScript(webScript)
    }

    function loginWhiteboard(){
        var jsonObj = {}
        var jsonParam = {}
        jsonObj.action = "jsLoginIMAndJoinWB"
        jsonParam.account = whiteboardAccount
        jsonParam.ownerAccount = whiteboardOwnerAccount
        jsonParam.token = whiteboardToken
        jsonParam.channelName = whiteboardChannelName
        jsonParam.record = whiteboardRecord
        jsonParam.debug = whiteboardDebug
        jsonParam.platform = Qt.platform.os === 'windows' ? 'pc' : 'mac'
        jsonParam.appKey = whiteboardAppKey
        jsonObj.param = jsonParam

        sendMessageToWeb(jsonObj);
    }

    function logoutWhiteboard(){
        var jsonObj = {}
        var jsonParam = {}
        jsonObj.action = "jsLogoutIMAndLeaveWB"
        jsonObj.param = jsonParam

        sendMessageToWeb(jsonObj);
    }

    function enableDraw(){
        var jsonObj = {}
        var jsonParam = {}
        jsonObj.action = "jsEnableDraw"
        jsonParam.enable = true
        jsonObj.param = jsonParam

        sendMessageToWeb(jsonObj);
    }

    function setWhiteboardColor(){
        var jsonObj = {}
        var jsonParam = {}
        jsonObj.action = "jsSetColor"
        jsonParam.color = getRandomColor()
        console.log("jsonParam.color", jsonParam.color)
        jsonObj.param = jsonParam

        sendMessageToWeb(jsonObj);
    }

    function getRandomColor()
    {
        var min = 1
        var max = 10
        var Range = max - min;
        var Rand = Math.random()
        var randomNum = min + Math.round(Rand * Range)

        var rgb = '';

        switch (randomNum){
        case 1:
            rgb = 'rgb(224,32,32)'
            break
        case 2:
            rgb = 'rgb(250,100,0)'
            break
        case 3:
            rgb = 'rgb(247,181,0)'
            break
        case 4:
            rgb = 'rgb(109,212,0)'
            break
        case 5:
            rgb = 'rgb(68,215,182)'
            break
        case 6:
            rgb = 'rgb(50,197,255)'
            break
        case 7:
            rgb = 'rgb(0,145,255)'
            break
        case 8:
            rgb = 'rgb(98,54,255)'
            break
        case 9:
            rgb = 'rgb(182,32,224)'
            break
        case 10:
            rgb = 'rgb(109,114,120)'
            break
        }

        return rgb
    }
}
