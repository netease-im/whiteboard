import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.14
import QtGraphicalEffects 1.0

Window {
    id: root
    width: 620
    height: 490
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
            height: 40
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
    }

    function showError(msg){
        repeater.itemAt(1).errMsg = errMsg
    }

    ColumnLayout{
        anchors.centerIn: parent
        spacing : 50

    Column{
        anchors.centerIn: parent
        spacing: 140

        Rectangle{
            width: 510
            height: 390

            ColumnLayout{
                spacing: 11
            CustomTextField{
                id: roomField
                placeText: "房间名称"
                str: NEMChatroomManager.getDefaultRoom()
            }
            CustomTextField{
                id: keyField
                placeText: "appkey"
                str: NEMChatroomManager.getDefaultAppkey()
                strWidth: 280
            }

            CustomTextField{
                id: wsUrlField
                placeText: "wsUrl"
                str: NEMChatroomManager.getDefaultWsUrl()
                strWidth: 480
            }

            Label {
                 text: "G2登录方式"
                 font.pixelSize: 22
                 font.italic: true
                 color: "steelblue"
                }
            CustomTextField{
                id: uidField
                placeText: "Uid"
                str: NEMChatroomManager.getDefaultUid()
            }
            CustomTextField{
                id: secretField
                placeText: "appsecret"
                str: NEMChatroomManager.getDefaultAppsecret()
                strWidth: 280
            }
            CustomTextField{
                id: staticUrlField2
                placeText: "G2静态资源地址"
                str: NEMChatroomManager.getDefaultStaticUrl2()
                strWidth: 510
            }
            Button{
                id: btn2
                text: "进入房间G2"
                enabled: (keyField.text.length !== 0 
                       && uidField.text.length != 0
                       && secretField.text != 0
                       && roomField.text != 0)
                Layout.preferredWidth : 140
                Layout.preferredHeight: 32
                Layout.alignment: Qt.AlignHCenter
                property bool isHover: false

                onClicked: {
                    NEMLoginManager.setLoginInfo(keyField.text, uidField.text, secretField.text)
                    NEMChatroomManager.setLoginChatroomInfo(roomField.text,
                                                            wsUrlField.text,
                                                            uidField.text,
                                                            secretField.text,
                                                            staticUrlField2.text)
                    NEMChatroomManager.setDefaultSettings(roomField.text, 
                                                          keyField.text,
                                                          wsUrlField.text,
                                                          uidField.text,
                                                          secretField.text,
                                                          staticUrlField2.text)
                }

                contentItem: Label {
                    text: btn2.text
                    font.pixelSize: 14
                    color: "#ffffff"
                    horizontalAlignment: Label.AlignHCenter
                    verticalAlignment: Label.AlignVCenter
                }

                background: Rectangle {
                    color: btn2.enabled ? (btn2.hovered ? "#2c8dff" : "#076bf2") : "#83b5f9"
                    radius: 2
                }

                MouseArea{
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor

                    onClicked: {
                        btn2.clicked()
                    }
                }
            }   
            }
        }
    }

    }
}
