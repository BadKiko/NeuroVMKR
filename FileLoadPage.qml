import QtQuick
import QtQuick.Controls 2.12
import "components"

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
            border.color: palette.mid
            radius: 16
            color: palette.dark

            Column {
                anchors.centerIn: parent
                spacing: 4

                TintedSVG {
                    anchors.centerIn: parent
                    source: "qrc:/qt/qml/NeuroVMKR/images/folder.svg"
                    tint: "blue"
                    width: 100
                    height: 100
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
