import QtQuick
import QtQuick.Controls
import QtMultimedia
import "components"

Page {
    id: root
    property var navigationFunctions
    property var videoFiles: []

    background: Rectangle {
        anchors.fill: parent
        color: palette.window
    }

    Column {
        anchors.centerIn: parent
        spacing: 20
        width: Math.min(parent.width * 0.8, 500)

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Обработка файлов"
            color: palette.text
            font.pointSize: 18
        }

        // Информация о загруженных файлах
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.videoFiles.length
                  > 0 ? `Загружено ${root.videoFiles.length} видео файл(ов)` : "Файлы не загружены"
            color: palette.text
            font.pointSize: 12
            opacity: 0.8
        }

        // Сетка файлов с видео-превью
        Grid {
            visible: root.videoFiles.length > 0
            anchors.horizontalCenter: parent.horizontalCenter
            columns: 3
            spacing: 15

            Repeater {
                model: root.videoFiles

                delegate: Item {
                    id: cardRoot
                    width: 200
                    height: 125

                    Rectangle {
                        anchors.fill: parent
                        border.width: 1.5
                        border.color: palette.mid
                        radius: 16
                        color: palette.dark
                    }

                    VideoThumbnail {
                        anchors.centerIn: parent
                        anchors.fill: parent
                        source: modelData
                    }

                    Text {
                        anchors.centerIn: parent
                        color: "white"
                        text: modelData
                    }
                }
            }
        }

        Button {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Назад"
            onClicked: root.navigationFunctions.popPage()
        }
    }
}
