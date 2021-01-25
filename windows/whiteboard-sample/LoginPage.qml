import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.14
import QtGraphicalEffects 1.0

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

        DragArea {
            id: drag
            height: 50
            width: parent.width
            anchors.left: parent.left
            anchors.top: parent.top
            title: "加入互动白板"
            isWhiteboardPage: false
            minVisible: false
            maxVisible: false

            onCloseClicked: {
                root.close()
            }
        }

        Label{
            text: "注：房间ID为创建房间后标题栏中间的数字"
            font.pixelSize: 12
            anchors.left: parent.left
            anchors.leftMargin: 378
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20
        }
    }

    function showError(msg){
        repeater.itemAt(1).errMsg = errMsg
    }

    Connections{
        target: NEMChatroomManager

        onJoinRoomFailed: {
            repeater.itemAt(1).errMsg = errMsg
        }
    }

    Connections{
        target: NEMChatroomManager

        onCreateRoomFailed: {
            repeater.itemAt(0).errMsg = errMsg
        }
    }

    Row{
        anchors.centerIn: parent
        spacing: 140

        Repeater {
            id: repeater
            model:ListModel{
                ListElement{imageSource:"qrc:/image/icon_createroom.png";placeText:"请输入房间名称"; btnName: "创建房间"; }
                ListElement{imageSource:"qrc:/image/icon_joinroom.png";placeText:"请输入房间ID号码"; btnName: "加入房间"; }
            }

            Rectangle{
                width:180
                height: 262
                property string errMsg: ""

                ColumnLayout{
                    spacing: 8

                    Image {
                        Layout.preferredWidth: 180
                        Layout.preferredHeight: 160
                        source: imageSource
                    }

                    Column{
                        spacing: 4
                        Layout.preferredWidth: 180
                        Layout.preferredHeight: 48

                        TextField {
                            id: textField
                            width: 180
                            height: 32
                            font.pixelSize: 14
                            placeholderText: placeText
                            leftPadding: 0

                            background: Rectangle {
                                implicitHeight: 32
                                implicitWidth: 180
                                color: "transparent"
                                border.width: 0

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
                                        implicitHeight: 2
                                        color: "#d7d6e1"
                                    }
                                }

                            }

                            onTextEdited: {
                                if(errMsg.length !== 0){
                                    errMsg = ""
                                }
                            }
                        }

                        Label{
                            visible: text.length != 0
                            text: errMsg
                            color: "#ff5454"
                        }

                    }

                    Button{
                        id: btn
                        text: btnName
                        enabled: textField.text.length !== 0
                        Layout.preferredWidth : 140
                        Layout.preferredHeight: 32
                        Layout.alignment: Qt.AlignHCenter
                        property bool isHover: false

                        onClicked: {
                            if(index == 0){
                                NEMChatroomManager.createChatroom(NEMLoginManager.getAccount(), textField.text)
                            } else{
                                NEMChatroomManager.loginChatroom(textField.text)
                            }
                        }

                        contentItem: Label {
                            text: btn.text
                            font.pixelSize: 14
                            color: "#ffffff"
                            horizontalAlignment: Label.AlignHCenter
                            verticalAlignment: Label.AlignVCenter
                        }

                        background: Rectangle {
                            color: btn.enabled ? (btn.hovered ? "#2c8dff" : "#076bf2") : "#83b5f9"
                            radius: 2
                        }

                        MouseArea{
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor

                            onClicked: {
                                btn.clicked()
                            }
                        }
                    }
                }
            }
        }
    }
}
