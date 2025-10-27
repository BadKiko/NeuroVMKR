import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import Qt.labs.folderlistmodel
import NeuroVMKR

Rectangle {
    id: container
    border.width: 1.5
    border.color: palette.mid
    radius: 16
    color: palette.dark

    property list<string> videoFiles: []
    signal filesLoaded(var files)

    RoundButton {
        visible: container.videoFiles.length > 0
        width: 36
        height: 36
        text: "✕"
        opacity: 0.5
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 8
        onClicked: {
            console.log("Clear button clicked, files count:",
                        container.videoFiles.length)
            container.videoFiles = []
            droparea_text.text = "Перетащите в область файлы или папку"
            droparea_icon.source = "qrc:///images/folder.svg"
            container.filesLoaded([])
        }
    }

    Column {
        anchors.centerIn: parent
        spacing: 4

        Image {
            id: droparea_icon
            anchors.horizontalCenter: parent.horizontalCenter
            source: "qrc:///images/folder.svg"
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

        FolderListModel {
            id: folderModel
            nameFilters: ["*.mp4", "*.mov"]
            showDirs: false
        }

        onEntered: {
            console.log("Drag entered drop area!")
            droparea_icon.source = "qrc:///images/upload.svg"
            parent.border.color = palette.accent
        }
        onExited: {
            console.log("Drag exited drop area!")
            droparea_icon.source = "qrc:///images/folder.svg"
            parent.border.color = palette.mid
        }
        onDropped: drop => {
                       droparea_icon.source = "qrc:///images/folder.svg"
                       parent.border.color = palette.mid

                       let newFiles = []

                       for (let url of drop.urls) {
                           const path = normalizePath(url)

                           if (isDirectory(path)) {
                               folderModel.folder = "file://" + path
                               for (var i = 0; i < folderModel.count; i++) {
                                   newFiles.push(folderModel.get(i, "filePath"))
                               }
                           } else if (isVideoFile(path)) {
                               newFiles.push(path)
                           }
                       }

                       container.videoFiles = newFiles

                       if (container.videoFiles.length > 0) {
                           droparea_text.text = `Загружено ${container.videoFiles.length} файл(ов)`
                           droparea_icon.source = "qrc:///images/clapperboard.svg"
                           container.filesLoaded(container.videoFiles)
                       } else {
                           droparea_text.text = `Перетащите файлы с расширением .mp4 или .mov или папки с ними в эту область`
                           droparea_icon.source = "qrc:///images/folder.svg"
                           container.filesLoaded([])
                       }
                   }

        function normalizePath(url) {
            return url.toString().replace("file://", "")
        }
        function isVideoFile(path) {
            return path.toLowerCase().endsWith(".mp4") || path.toLowerCase(
                        ).endsWith(".mov")
        }

        function isDirectory(path) {
            return !path.includes(".") || path.endsWith("/")
        }
    }
}
