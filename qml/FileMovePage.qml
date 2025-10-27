pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtMultimedia

Page {
    id: root
    property var videoFiles: []
    property var navigationFunctions: null

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
                delegate: Rectangle {
                    width: 200
                    height: 140
                    border.width: 1.5
                    border.color: palette.mid
                    radius: 12
                    color: palette.dark

                    Column {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 6

                        // Видео-превью
                        Video {
                            id: videoPreview
                            width: parent.width - 16
                            height: 100
                            source: root.videoFiles[index]
                            autoPlay: false
                            loops: MediaPlayer.Infinite

                            Component.onCompleted: {
                                if (root.videoFiles && root.videoFiles[index]) {
                                    source = root.videoFiles[index]
                                }
                            }

                            // Показываем первый кадр и останавливаемся
                            onPlaying: {
                                seek(0) // Переходим к началу
                                pause() // Останавливаем на первом кадре
                            }
                        }

                        // Имя файла
                        Text {
                            width: parent.width - 16
                            text: {
                                var filePath = root.videoFiles[index] || ""
                                return filePath.split('/').pop()
                            }
                            color: palette.text
                            font.pointSize: 10
                            opacity: 0.8
                            elide: Text.ElideMiddle
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
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
