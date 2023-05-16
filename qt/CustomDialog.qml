import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12

Dialog {
    id: root
    width: 330
    height: 160
    modal: true
    padding: 0
    leftInset: 0
    rightInset: 0
    topInset: 0
    bottomInset: 0
    margins: 0
    focus: false
    closePolicy: Popup.NoAutoClose

    background: Rectangle {
        radius: 8
    }
    x: (parent.width - width) / 2
    y: (parent.height - height) / 2
    enter: null
    exit: null

    property alias text: title.text
    property alias description: description.text
    property string cancelBtnText : qsTr("Cancel")
    property string confirmBtnText : qsTr("OK")
    signal confirm
    signal cancel

    onClosed: {
        // When created dynamically, is called when the dialog is closed only but the parent object is not destroyed
        //root.destroy()
    }

    Label {
        id: title
        width: parent.width
        font.pixelSize: 18
        wrapMode: Text.WrapAnywhere
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    Label {
        id: description
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 20
        height: 30
        anchors.top: title.bottom
        anchors.topMargin: 15
        font.pixelSize: 14
        wrapMode: Text.WrapAnywhere
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    ToolSeparator {
        width: parent.width
        anchors.left: parent.left
        anchors.bottom: confirm.top
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

    ToolSeparator {
        visible: cancel.visible
        anchors.top: confirm.top
        anchors.left: confirm.right
        anchors.leftMargin: 1
        orientation: Qt.Vertical
        padding: 0
        bottomInset: 0
        topInset: 0
        leftInset: 0
        rightInset: 0
        spacing: 0
        verticalPadding: 0
        horizontalPadding: 0
        contentItem: Rectangle {
            implicitWidth: 1
            implicitHeight: confirm.height
            color: "#EBEDF0"
        }
    }

    CustomButton {
        id: confirm
        anchors.left: parent.left
        anchors.leftMargin: 0/*cancel.visible ? 0 : 80*/
        anchors.bottom: parent.bottom
        width: cancel.visible ? parent.width / 2 - 1 : parent.width
        height: 48
        text: qsTr(confirmBtnText)
        font.pixelSize: 14
        buttonRadius: 8
        borderColor: "#FFFFFF"
        normalTextColor: "#337EFF"
        borderSize: 0
        onClicked: {
            root.confirm()
            root.close()
        }
    }

    CustomButton {
        id: cancel
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        font.pixelSize: 14
        visible: cancelBtnText.length != 0
        width: parent.width / 2 - 1
        height: 48
        text: qsTr(cancelBtnText)
        buttonRadius: 8
        borderColor: "#FFFFFF"
        normalTextColor: "#333333"
        borderSize: 0
        onClicked: {
            root.cancel()
            root.close()
        }
    }
}
