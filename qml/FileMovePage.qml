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

        Grid {
            id: filesGrid
            anchors.horizontalCenter: parent.horizontalCenter
            columns: 3
            spacing: 8

            Repeater {
                id: repeatRoot
                model: root.videoFiles

                delegate: Rectangle {
                    id: cardRoot
                    width: 200
                    height: 135
                    radius: 6
                    color: palette.window
                    border.width: 1

                    property var gridRef
                    property var rootRef

                    MouseArea {
                        anchors.fill: parent
                        drag.target: parent

                        drag.minimumX: 0
                        drag.maximumX: cardRoot.gridRef.width - 200
                        drag.minimumY: 0
                        drag.maximumY: cardRoot.gridRef.y - 25

                        onReleased: {
                            var newPosInGridX = Math.round(
                                        parent.x / (parent.width + cardRoot.gridRef.spacing))

                            var newPosInGridY = Math.round(
                                        parent.y / (parent.height + cardRoot.gridRef.spacing))

                            // вычисляем координаты ближайшей ячейки
                            var targetX = newPosInGridX * (parent.width + cardRoot.gridRef.spacing)
                            var targetY = newPosInGridY * (parent.height + cardRoot.gridRef.spacing)

                            var indexInGrid = newPosInGridY
                                    * cardRoot.gridRef.columns + newPosInGridX

                            var oldIndex = cardRoot.rootRef.videoFiles.index(
                                        modelData)

                            cardRoot.rootRef.videoFiles.move(indexInGrid,
                                                             oldIndex, 1)

                            // запускаем анимацию
                            animateX.to = targetX
                            animateY.to = targetY
                            animateX.running = true
                            animateY.running = true
                        }
                    }

                    NumberAnimation {
                        id: animateX
                        target: cardRoot
                        property: "x"
                        duration: 200
                        easing.type: Easing.OutQuad
                    }
                    NumberAnimation {
                        id: animateY
                        target: cardRoot
                        property: "y"
                        duration: 200
                        easing.type: Easing.OutQuad
                    }

                    // содержимое карточки
                    Rectangle {
                        anchors.fill: parent
                        color: palette.dark
                        radius: 12
                        Column {
                            anchors.fill: parent
                            Item {
                                height: 112
                                width: 200
                                VideoThumbnail {
                                    anchors.fill: parent
                                    anchors.margins: 1
                                    source: modelData
                                }
                            }
                            Text {
                                height: 23
                                anchors.horizontalCenter: parent.horizontalCenter
                                color: palette.text
                                text: modelData.replace("file:///",
                                                        "").split('/').pop()
                                verticalAlignment: Text.AlignVCenter
                                font.pointSize: 10
                            }
                        }
                    }
                }
                Component.onCompleted: {
                    for (var i = 0; i < repeatRoot.count; ++i) {
                        var item = repeatRoot.itemAt(i)
                        item.gridRef = filesGrid
                        item.rootRef = root
                    }
                }
            }
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
