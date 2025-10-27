import QtQuick
import QtQuick.Controls

Page {
    id: root
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

        // Сетка файлов (если нужно показать детали)
        Grid {
            visible: root.videoFiles.length > 0
            anchors.horizontalCenter: parent.horizontalCenter
            columns: 3
            spacing: 10
            Repeater {
                model: root.videoFiles
                delegate: Rectangle {
                    width: 150
                    height: 50
                    border.width: 1.5
                    border.color: palette.mid
                    radius: 16
                    color: palette.dark
                    Text {
                        anchors.centerIn: parent
                        width: parent.width - 10
                        text: modelData.split('/').pop(
                                  ) // Показываем только имя файла
                        color: palette.text
                        font.pointSize: 12
                        opacity: 0.7
                        elide: Text.ElideMiddle
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
        }

        Button {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Назад"
            onClicked: mainWindow.popPage()
        }
    }
}
