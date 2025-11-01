import QtQuick
import QtQuick.Controls
import "components"

Page {
    id: root
    property var navigationFunctions
    property var videoFiles: []

    background: Rectangle {
        id: page
        anchors.fill: parent
        color: palette.window
    }

    Column {
        id: contentColumn
        width: parent.width - 12
        anchors.centerIn: parent
        spacing: 20

        Column {
            width: parent.width
            spacing: 8
            Text {
                id: titleText
                text: "Видео успешно загружены"
                color: palette.text
                font.pointSize: 14
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                id: hintText
                text: "Перетащите видео в том порядке, в котором хотите, чтобы нейросеть создала контекст истории, или включите авто — нейросеть сама попробует построить логическую последовательность."
                color: palette.text
                font.pointSize: 10
                opacity: 0.8
                wrapMode: Text.Wrap
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width - 20
            }
        }

        Button {
            width: filesGrid.width
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Авто-история"
        }

        VideoDragNDropGrid {
            id: filesGrid
            anchors.horizontalCenter: parent.horizontalCenter
            columns: 3
            spacing: 8
            videoFiles: root.videoFiles
            onVideoMoved: videoFiles => root.videoFiles = videoFiles
        }

        Item {
            width: 1
            height: 8
        }

        Row {
            Button {
                id: backButton
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Назад"
                onClicked: root.navigationFunctions.popPage()
            }
            Button {
                id: nextButton
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Назад"
                onClicked: root.navigationFunctions.popPage()
            }
        }
    }
}
