import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.14
import QtGraphicalEffects 1.0
import QtQuick.Dialogs 1.2

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
                    root.hide()
                    close.accepted = false
                }

                function cancel(){
                    return
                }

                var tip = "确定要退出房间？"
                var confirmText = "退出房间"              
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
            whiteboardUid: NEMLoginManager.getUid()
            whiteboardChannelName: NEMChatroomManager.getRoomid()
            whiteboardRecord: false
            whiteboardDebug: true
            defaultDownloadPath: WhiteboardHelper.getDefaultDownloadPath()
            whiteboardUrl: NEMChatroomManager.getWhiteboardUrl()
            whiteboardWsUrl: NEMChatroomManager.getWsUrl()

            function confirm(){
                NEMChatroomManager.logoutChatroom()
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
