import QtQuick
import QtQuick.Controls 2.12
import QtQuick.Effects

Page {
    background: Rectangle {
        anchors.fill: parent
        color: palette.window
    }

    Column {
        anchors.fill: parent
        anchors.topMargin: 16

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "🪄 AI Video Editor NVMKR 🪄"
            color: palette.text
            font.pointSize: 13
            font.bold: true
        }

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

                Image {
                    id: droparea_icon
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: "images/folder.svg"
                    fillMode: Image.PreserveAspectFit
                    sourceSize.width: 64
                    sourceSize.height: 64
                    layer.enabled: true
                    layer.effect: MultiEffect {
                        brightness: 1.0
                        colorization: 1.0
                        colorizationColor: palette.accent
                    }
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Перетащите в область файлы или папку"
                    color: palette.text
                }
            }

            DropArea {
                anchors.fill: parent
                property var videoFiles: []

                ListModel {
                    id: folderModel
                    nameFilters: ["*.mp4", "*.mov"]
                    showDirs: false
                }

                onDropped: drop => {
                               drop.acceptProposedAction()
                               videoFiles = []

                               for (let url of drop.urls) {
                                   const path = normalizePath(url)
                                   const info = FileInfo(path)

                                   if (info.isDir) {
                                       folderModel.folder = "file://" + path
                                       for (var i = 0; i < folderModel.count; i++) {
                                           videoFiles.push(folderModel.get(
                                                               i, "filePath"))
                                       }
                                   } else if (isVideoFile(path)) {
                                       videoFiles.push(path)
                                   }
                               }

                               console.log("Найдено видеофайлов:",
                                           videoFiles.length)
                           }

                function normalizePath(url) {
                    return url.toString().replace("file://", "")
                }
                function isVideoFile(path) {
                    return path.endsWith(".mp4") || path.endsWith(".mov")
                }
            }
        }
    }
}
