import QtQuick
import QtQuick.Controls

Page {

    background: Rectangle {
        id: page
        anchors.fill: parent
        color: palette.window
    }

    Column {
        id: column
        spacing: 20
        anchors.centerIn: parent
        width: Math.min(parent.width * 0.8, 500)
        property var selectedVideoFiles: []

        // Заголовок приложения
        Column {
            spacing: 8
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "NeuroVMKR"
                color: palette.text
                font.pointSize: 24
                font.bold: true
                font.letterSpacing: 1.2
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Обработка и анализ видеофайлов"
                color: palette.text
                font.pointSize: 12
                opacity: 0.8
            }
        }

        // Область перетаскивания
        FileDragDrop {
            id: fileDrop
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width
            height: 220
            onFilesLoaded: videoFiles => {
                               column.selectedVideoFiles = videoFiles
                           }
        }

        // Кнопка продолжения
        Button {
            visible: column.selectedVideoFiles.length > 0
            width: parent.width
            text: "Продолжить"
        }
    }
}
