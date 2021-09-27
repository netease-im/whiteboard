import QtQuick 2.0
import QtQuick.Controls 2.12

TextField  {
    id: root
    property string placeText: ""
    property string str: ""
    property int strWidth: 180

    width: strWidth
    height: 32
    font.pixelSize: 14
    placeholderText: placeText
    text: str
    leftPadding: 0

    background:Rectangle{
        implicitHeight: 32
        implicitWidth: strWidth
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

// 

}
