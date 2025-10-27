import QtQuick
import QtQuick.Controls

Page {
    background: Rectangle {
        anchors.fill: parent
        color: palette.window
    }

    Column {
        anchors.centerIn: parent
        spacing: 20

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "FileMovePage"
            color: palette.text
            font.pointSize: 18
        }

        Button {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Назад"
            onClicked: navStack.pop()
        }
    }
}
