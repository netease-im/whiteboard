import QtQuick 2.6
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtWebChannel 1.0
import QtWebEngine 1.1
import NEMJsBridge 1.0

Item {
    id: root
    visible: true

    property string whiteboardUrl: ""
    property string whiteboardChannelName: ""
    property string whiteboardAppKey: ""
    property bool whiteboardRecord: false
    property bool whiteboardDebug: false
    property string defaultDownloadPath: ""
    property string whiteboardWsUrl: ""
    property int whiteboardUid: 123

    signal createWriteBoardSucceed()
    signal createWriteBoardFailed(string errorMessage)
    signal joinWriteBoardSucceed()
    signal joinWriteBoardFailed(string errorMessage)
    signal leaveWriteBoard()
    signal writeBoardError(string errorMessage)
    signal loginIMSucceed()
    signal loginIMFailed(string errorMessage)
    signal downloadFinished(string path)

    NEMJsBridge {
        id: jsBridge
        WebChannel.id: "qJsBridge"

        onWebPageLoadFinished: {
            loginWhiteboard()
        }

        onWebCreateWriteBoardSucceed: {
            createWriteBoardSucceed()
        }

        onWebCreateWriteBoardFailed: {
            createWriteBoardFailed(errorMessage)
        }

        onWebJoinWriteBoardSucceed: {
            console.log("onWebJoinWriteBoardSucceed")
            setWhiteboardColor()
            enableDraw()
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

        onWebLog:{
            NEMGlog.setlogInfo(logMessage)
        }

        onWebGetAuth:{
            NEMChatroomManager.setCheckSum();      
            var jsonObjAuth = {}
            var jsonParamAuth = {}
            jsonObjAuth.action = "jsSendAuth"
            jsonParamAuth.code = 200
            jsonParamAuth.nonce = NEMChatroomManager.getNonce()
            jsonParamAuth.checksum = NEMChatroomManager.getCheckSum()
            jsonParamAuth.curTime = NEMChatroomManager.getCurTime()
            jsonObjAuth.param = jsonParamAuth
            sendMessageToWeb(jsonObjAuth);
        }

    }

    WebEngineView {
        id: webview
        anchors.fill: parent
        url: whiteboardUrl
        webChannel: channel
        onCertificateError: error.ignoreCertificateError()
        property var downloads;
        profile.onDownloadRequested: {
            var arr = download.path.split('/');
            var name = arr[arr.length - 1];
            download.path = defaultDownloadPath + "/" + name;
            webview.downloads = download;
            download.accept();
        }

        profile.onDownloadFinished: {
            downloadFinished(download.path)
        }
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
        jsonObj.action = "jsJoinWB"
        jsonParam.uid = whiteboardUid;
        jsonParam.channelName = whiteboardChannelName
        jsonParam.record = whiteboardRecord
        jsonParam.debug = whiteboardDebug
        jsonParam.platform = 'pc'
        jsonParam.appKey = whiteboardAppKey

        if(0 != whiteboardWsUrl.length)
        {
            jsonParam.wsUrl = whiteboardWsUrl
        }

        jsonObj.param = jsonParam

        sendMessageToWeb(jsonObj);
        
    }

    function logoutWhiteboard(){
        var jsonObj = {}
        var jsonParam = {}
        jsonObj.action = "jsLeaveWB"
        jsonObj.param = jsonParam

        sendMessageToWeb(jsonObj);
    }

    function enableDraw(){
        var jsonObj = {}
        var jsonParam = {}
        var paramArray = [true]

        jsonObj.action = "jsDirectCall"
        jsonParam.target = "drawPlugin"
        jsonParam.action = "enableDraw"
        jsonParam.params = paramArray
        jsonObj.param = jsonParam

        sendMessageToWeb(jsonObj);
    }

    function setWhiteboardColor(){
        var jsonObj = {}
        var jsonParam = {}

        var color = getRandomColor()
        var paramArray = [color]

        jsonObj.action = "jsDirectCall"
        jsonParam.target = "drawPlugin"
        jsonParam.action = "setColor"
        jsonParam.params = paramArray
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
