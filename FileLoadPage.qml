import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import Qt.labs.folderlistmodel

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
            id: container
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
                    id: droparea_text
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Перетащите в область файлы или папку"
                    color: palette.text
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                    width: container.width
                }
            }

            DropArea {
                id: droparea
                anchors.fill: parent
                property var videoFiles: []

                FolderListModel {
                    id: folderModel
                    nameFilters: ["*.mp4", "*.mov"]
                    showDirs: false
                }

                onEntered: {
                    console.log("Drag entered drop area!")
                    droparea_icon.source = "images/upload.svg"
                    parent.border.color = palette.accent
                }
                onExited: {
                    console.log("Drag exited drop area!")
                    droparea_icon.source = "images/folder.svg"
                    parent.border.color = palette.mid
                }
                onDropped: drop => {
                               droparea_icon.source = "images/folder.svg"
                               parent.border.color = palette.mid
                               videoFiles = []

                               for (let url of drop.urls) {
                                   const path = normalizePath(url)

                                   if (isDirectory(path)) {
                                       folderModel.folder = "file://" + path
                                       for (var i = 0; i < folderModel.count; i++) {
                                           videoFiles.push(folderModel.get(
                                                               i, "filePath"))
                                       }
                                   } else if (isVideoFile(path)) {
                                       videoFiles.push(path)
                                   }
                               }
                               if (videoFiles.length > 0) {
                                   droparea_text.text = `Загружено ${videoFiles.length} файл(ов)`
                                   droparea_icon.source = "images/clapperboard.svg"
                               } else {
                                   droparea_text.text = `Перетащите в область файлы или папку`
                                   droparea_icon.source = "images/folder.svg"
                               }
                           }

                function normalizePath(url) {
                    return url.toString().replace("file://", "")
                }
                function isVideoFile(path) {
                    return path.toLowerCase().endsWith(".mp4")
                            || path.toLowerCase().endsWith(".mov")
                }

                function isDirectory(path) {
                    return !path.includes(".") || path.endsWith("/")
                }
            }
        }

        Button {
            anchors.horizontalCenter: parent.horizontalCenter
            width: droparea.width
            Text {
                text: "Продолжить"
            }
        }
    }
}
