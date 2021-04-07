import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.14
import QtGraphicalEffects 1.0
import QtQuick.Dialogs 1.2

import NEMWhiteboard 1.0

Window {
    id: root
    width: 1280
    height: 800
    visible: true
    color: '#ffffff'
    flags: Qt.Window | Qt.FramelessWindowHint

    function dynamicDialog(title, message, confirm, cancel , confirmText = "ok", cancelText = "cancel", parent = root , shadow = true) {
        const dialogHandle = Qt.createComponent("CustomDialog.qml").createObject(parent, {
            text: title,
            description: message,
            dim: shadow,
            cancelBtnText: cancelText,
            confirmBtnText: confirmText
        })
        dialogHandle.confirm.connect(confirm)
        dialogHandle.cancel.connect(cancel)
        dialogHandle.open()
    }

    onVisibilityChanged: {
        //解决Qt窗口最大化的时候最小化，再恢复窗口变为普通窗口的bug
        if(drag.isMax && visibility === 2) {
            showMaximized()
        }
    }

    Connections {
        target: NEMChatroomManager

        onKickByMultiSpot: {
            console.log("onKickByMultiSpot")
            whiteboard.logoutWhiteboard()

            function confirm(){
                NEMChatroomManager.logoutChatroom()
                root.hide()
                close.accepted = false
            }

            function cancel(){
                return
            }
            dynamicDialog("", "不允许同一个账号重复登录同一个房间，请确认退出！", confirm, cancel, "确定", "")
        }

        onChatRoomFinished: {
            console.log("onChatRoomFinished")
            whiteboard.logoutWhiteboard()

            var tip = "";

            if(NEMChatroomManager.getCreator() === NEMLoginManager.getAccount()){
                tip = "抱歉，因在其他设备创建房间，本账号将被强制退出！";
            }else{
                tip = "房间已结束教学，请确认退出！";
            }

            function confirm(){
                NEMChatroomManager.logoutChatroom()
                root.hide()
                close.accepted = false
            }

            function cancel(){
                return
            }

            dynamicDialog("", tip, confirm, cancel, "确定", "")
        }

        onKickByManager: {
            console.log("onKickByManager")
            whiteboard.logoutWhiteboard()

            function confirm(){
                NEMChatroomManager.logoutChatroom()
                root.hide()
                close.accepted = false
            }

            function cancel(){
                return
            }
            dynamicDialog("", "抱歉，您已被踢出该房间", confirm, cancel, "确定", "")
        }
    }

    Rectangle{
        id: mainLayout
        anchors.fill: parent
        anchors.margins: 0
        color: "#ffffff"
        border.width: 2
        border.color: "#dfdfe1"

        ToastManager {
            id: toast
        }

        DragArea {
            id: drag
            height: 50
            width: parent.width
            anchors.left: parent.left
            anchors.top: parent.top
            title: "房间号：" + NEMChatroomManager.getRoomid()
            roomid: NEMChatroomManager.getRoomid()
            nickname: NEMLoginManager.getAccount()
            onCloseClicked: {
                function confirm(){
                    NEMChatroomManager.logoutChatroom()
                    if(NEMChatroomManager.getCreator() === NEMLoginManager.getAccount()){
                         NEMChatroomManager.closeChatroom()
                    }

                    root.hide()
                    close.accepted = false
                }

                function cancel(){
                    return
                }

                var tip = ""
                var confirmText = ""
                if(NEMChatroomManager.getCreator() === NEMLoginManager.getAccount()){
                    tip = "确定要结束教学？"
                    confirmText = "结束教学"
                }else{
                    tip = "确定要退出房间？"
                    confirmText = "退出房间"
                }

                dynamicDialog("", tip, confirm, cancel, confirmText, "取消")
            }
        }

        NEMWhiteboard {
            id: whiteboard
            anchors.left: drag.left
            anchors.leftMargin: mainLayout.border.width
            anchors.top: drag.bottom
            width: parent.width - mainLayout.border.width * 2
            height: parent.height - drag.height - mainLayout.border.width

            whiteboardAppKey: NEMLoginManager.getAppKey()
            whiteboardAccount: NEMLoginManager.getAccount()
            whiteboardToken: NEMLoginManager.getPassword()
            whiteboardChannelName: NEMChatroomManager.getRoomid()
            whiteboardOwnerAccount: NEMChatroomManager.getCreator()
            whiteboardRecord: false
            whiteboardDebug: false
            defaultDownloadPath: WhiteboardHelper.getDefaultDownloadPath()
            whiteboardUrl: "https://app.yunxin.163.com/webdemo/whiteboard/webview.html"

            function confirm(){
                NEMChatroomManager.logoutChatroom()
                if(NEMChatroomManager.getCreator() === NEMLoginManager.getAccount()){
                     NEMChatroomManager.closeChatroom()
                }
                root.hide()
                close.accepted = false
            }

            function cancel(){
                return
            }

            onCreateWriteBoardFailed: {
                dynamicDialog("", "创建白板失败" , confirm, cancel, "确定", "")
            }

            onJoinWriteBoardFailed: {
                dynamicDialog("", "加入白板失败" , confirm, cancel, "确定", "")
            }

            onLoginIMFailed: {
                dynamicDialog("", "加入白板失败", confirm, cancel, "确定", "")
            }

            onDownloadFinished: {
                WhiteboardHelper.openDir(path)
                toast.show("图片导出中...")
            }
        }
    }
}
