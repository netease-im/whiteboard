import QtQuick 2.0
import QtQuick.Controls 2.12

RoundButton {
    property var highNormalBkColor: "#337EFF"
    property var highPushedBkColor: "#337EEE"
    property var highDisabledBkColor: "#88337EFF"
    property var normalBkColor: "#FFFFFF"
    property var pushedBkColor: "#F5F5F5"

    property var disabledBkColor: "#88337EFF"
    property var highBorderColor: "#337EFF"
    property var borderColor: "#337EFF"
    property var borderSize: 1
    property var disabledBorderColor: "#88337EFF"

    property var highTextColor: "#FFFFFF"
    property var normalTextColor: "#337EFF"
    property var disabledTextColor: "#FFFFFF"
    property var buttonRadius: 0

    id: control
    hoverEnabled: true
    onHoveredChanged: hovered ? control.opacity = .9 : control.opacity = 1
    padding: 0
    bottomInset: 0
    topInset: 0
    leftInset: 0
    rightInset: 0

    contentItem: Label {
        text: control.text
        font: control.font
        color: enabled ? control.highlighted ? highTextColor : normalTextColor : disabledTextColor
        horizontalAlignment: Label.AlignHCenter
        verticalAlignment: Label.AlignVCenter
        elide: Label.ElideRight
    }

    background: Rectangle {
        color: {
            if (control.highlighted) {
                if (control.down) return highPushedBkColor
                if (!enabled) return highDisabledBkColor
                return highNormalBkColor
            } else {
                if (control.down) return pushedBkC
                if (!enabled) return disabledBkColor
                return normalBkColor
            }
        }
        // opacity: enabled ? 1.0 : 0.5
        border.color: enabled ? (highlighted ? highBorderColor : borderColor) : disabledBorderColor
        border.width: borderSize
        radius: buttonRadius <= 0 ? control.height / 2 : buttonRadius
    }
}
