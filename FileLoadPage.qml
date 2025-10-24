import QtQuick
import QtQuick.Controls 2.12

Page {
    title: "Страница 1"
    Rectangle {
            anchors.fill: parent
            color: "#f0f0f0"

            Rectangle {
                id: dropZone
                width: 300
                height: 100
                anchors.centerIn: parent
                color: dropArea.containsDrag ? "#a0ffa0" : "#ffffff"
                border.color: "#000000"
                border.width: 2
                radius: 5

                Text {
                    anchors.centerIn: parent
                    text: "Перетащите сюда файл"
                    font.pointSize: 14
                }

                DropArea {
                    id: dropArea
                    anchors.fill: parent

                    onDropped: {
                        for (var i = 0; i < drop.proposedUrls.length; i++) {
                            console.log("Файл:", drop.proposedUrls[i])
                        }
                    }
                }
            }
        }
}
