import QtQuick 2.14
import QtQuick.Window 2.14
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.12

Window {
    id: root
    width: 640
    height: 400
    visible: true
    color: 'transparent'
    flags: Qt.Window | Qt.FramelessWindowHint

    DropShadow {
        anchors.fill: mainLayout
        horizontalOffset: 0
        verticalOffset: 0
        samples: 30
        source: mainLayout
        color: "#3217171A"
        spread: 0.3

        visible: Qt.platform.os === 'windows'
        Behavior on radius { PropertyAnimation { duration: 100 } }
    }

    Rectangle{
        id: mainLayout
        anchors.fill: parent
        anchors.margins:  Qt.platform.os === 'windows' ? 10 : 0
        Label {
            text: "正在登录..."
            font.pixelSize: 16
            anchors.centerIn: parent
        }

    }

    Connections {
        target: NEMLoginManager

        onLoginFinished: {
            loader.sourceComponent = comLogin
            root.hide()
        }
    }

    Connections {
        target: NEMLoginManager

        onEnterRoomFinished: {
            console.log("start load whiteboard...")
            loader.sourceComponent = comWhiteboard
        }

        onExitRoom: {
            console.log("onExitRoom")
            loader.sourceComponent = comLogin
        }
    }

    Loader{
        id: loader
    }

    Component {
        id: comLogin
        LoginPage {
            id: login
        }
    }

    Component {
        id: comWhiteboard
        WhiteboardPage{
            id: whiteboard
        }
    }

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

}
