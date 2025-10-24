import QtQuick
import QtQuick.Controls 2.12

Page {
    background: Rectangle {
        anchors.fill: parent
        color: palette.window
    }

    Column {
        anchors.fill: parent

        Rectangle {
            anchors.centerIn: parent
            width: parent.width / 2
            height: 200
            border.width: 1.5
            border.color: "gray"
            radius: 16

            Column {
                anchors.centerIn: parent
                spacing: 4

                Image {
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: "images/folder.svg"
                    fillMode: Image.PreserveAspectFit
                    sourceSize.width: 64
                    sourceSize.height: 64
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Перетащите в область файлы или папку"
                    color: palette.text
                }
            }
        }
    }
}
