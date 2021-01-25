import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Window 2.2
import Clipboard 1.0

Item {
    property string title: ''
    property string nickname: ''
    property string roomid: ''
    property int titleFontSize: 14
    property bool minVisible: true
    property bool maxVisible: true
    property bool closeVisible: true
    property bool closeIsHide: true
    property bool windowMode: true
    property bool isMax: false
    property bool isWhiteboardPage: true

    signal closeClicked()
    signal maxClicked(bool max)

    function close() {
        idCloseButton.clicked()
    }

    Clipboard {
        id: clipboard
    }

    MouseArea {
        property int lastWindowWidth: 0
        property int lastWindowHeight: 0
        property point movePos: '0,0'

        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        enabled: windowMode
        onPressed: {
            movePos = Qt.point(mouse.x, mouse.y)
            lastWindowWidth = Window.window.width
            lastWindowHeight = Window.window.height
        }
        onPositionChanged: {
            const delta = Qt.point(mouse.x - movePos.x, mouse.y - movePos.y)
            if (Window.window.visibility !== Window.Maximized && Window.window.visibility !== Window.FullScreen) {
                if(Window.window.y + delta.y < 0){
                    return
                }

                if(Window.window.x + delta.x < -Window.window.width / 2){
                    return
                }

                if(Window.window.x + delta.x > Screen.width - Window.window.width / 2){
                    return
                }

                if(Window.window.y + delta.y > Screen.height - Window.window.height / 2){
                    return
                }

                Window.window.x = Window.window.x + delta.x
                Window.window.y = Window.window.y + delta.y
                Window.window.width = lastWindowWidth
                Window.window.height = lastWindowHeight
            }
        }
    }

    RowLayout {
        visible: isWhiteboardPage
        anchors.left : parent.left
        anchors.leftMargin: 24
        anchors.verticalCenter: parent.verticalCenter
        spacing: 24

        Label {
            text: nickname
            font.pixelSize: 14
        }

        Label {
            text: NEMChatroomManager.getCreator() === NEMLoginManager.getAccount() ? qsTr("退出教学") : qsTr("退出房间")
            font.pixelSize: 14
            color: "#337EFF"
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    closeClicked()
                }
            }
        }
    }

    RowLayout {
        spacing: 8
        anchors.verticalCenter: parent.verticalCenter
        anchors.right : parent.right
        anchors.rightMargin: 16
        visible: true
        ImageButton {
            visible: minVisible
            Layout.preferredHeight: 36
            Layout.preferredWidth: 36
            normalImage: 'qrc:/image/min.svg'
            hoveredImage: 'qrc:/image/min.svg'
            pushedImage: 'qrc:/image/min.svg'
            onClicked: {
                Window.window.showMinimized()
            }
        }
        ImageButton {
            id: btnMax
            visible: maxVisible
            Layout.preferredHeight: 36
            Layout.preferredWidth: 36
            normalImage: 'qrc:/image/max.svg'
            hoveredImage: 'qrc:/image/max.svg'
            pushedImage: 'qrc:/image/max.svg'
            onClicked: {
                isMax = !isMax

                if(isMax){
                    Window.window.showMaximized()
                    normalImage = 'qrc:/image/restore.svg'
                    hoveredImage = 'qrc:/image/restore.svg'
                    pushedImage = 'qrc:/image/restore.svg'
                    maxClicked(true)
                } else{
                    Window.window.showNormal()
                    normalImage = 'qrc:/image/max.svg'
                    hoveredImage = 'qrc:/image/max.svg'
                    pushedImage = 'qrc:/image/max.svg'
                    maxClicked(false)
                }

            }
        }
        ImageButton{
            id: idCloseButton
            visible: true
            Layout.preferredHeight: 36
            Layout.preferredWidth: 36
            normalImage: 'qrc:/image/close.svg'
            hoveredImage: 'qrc:/image/close.svg'
            pushedImage: 'qrc:/image/close.svg'
            onClicked: {
                closeClicked()
            }
        }
    }

    RowLayout{
       anchors.centerIn: parent
       spacing: 0

       Label {
           text: title
           font.pixelSize: 14
       }

       ImageButton{
           visible: isWhiteboardPage
           Layout.preferredHeight: 36
           Layout.preferredWidth: 36
           normalImage: 'qrc:/image/copy.svg'
           hoveredImage: 'qrc:/image/copy.svg'
           pushedImage: 'qrc:/image/copy.svg'
           onClicked: {
               clipboard.setText(roomid)
               toast.show("已复制房间号：" + roomid)
           }
       }
    }

    ToolSeparator {
        width: parent.width
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        verticalPadding: 0
        horizontalPadding: 0
        padding: 0
        leftInset: 0
        rightInset: 0
        topInset: 0
        bottomInset: 0
        orientation: Qt.Horizontal
        contentItem: Rectangle {
            implicitWidth: parent.width
            implicitHeight: 1
            color: "#dfdfe1"
        }
    }
}
