import QtQuick 2.12
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Button {
    id: root
    property string normalImage: ""
    property string hoveredImage: ""
    property string pushedImage: ""
    style: ButtonStyle {
        background: Rectangle{
            implicitHeight: root.height
            implicitWidth:  root.width
            color: "transparent"
            BorderImage{
                anchors.fill: parent
                source: root.hovered ? (control.pressed ? pushedImage : hoveredImage) : normalImage;
            }
        }
    }

    MouseArea{
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            root.clicked()
        }
    }
}
