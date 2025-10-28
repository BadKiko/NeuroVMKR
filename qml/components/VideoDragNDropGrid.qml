import QtQuick

Grid {
    id: filesGrid
    property int cellWidth: 200
    property int cellHeight: 135
    spacing: 10
    columns: Math.max(1, Math.floor(width / (cellWidth + spacing)))

    Repeater {
        id: repeatRoot
        model: root.videoFiles

        delegate: Item {
            id: cardRoot

            property VideoDragNDropGrid gridRef

            width: gridRef.cellWidth
            height: gridRef.cellHeight

            property bool isDragging: false
            property int startIndex: index
            property int hoverIndex: index
            property int startX: 0
            property int startY: 0

            function gridPos(i) {
                return Qt.point(
                            Math.floor(
                                i % gridRef.columns) * (gridRef.cellWidth + gridRef.spacing),
                            Math.floor(
                                i / gridRef.columns) * (gridRef.cellHeight + gridRef.spacing))
            }

            // --- динамическая позиция
            x: gridPos(displayIndex).x
            y: gridPos(displayIndex).y

            // Индекс для отрисовки, не обязательно совпадает с реальным index
            property int displayIndex: index

            Behavior on x {
                enabled: !cardRoot.isDragging
                NumberAnimation {
                    duration: 180
                    easing.type: Easing.OutQuad
                }
            }
            Behavior on y {
                enabled: !cardRoot.isDragging
                NumberAnimation {
                    duration: 180
                    easing.type: Easing.OutQuad
                }
            }

            // bounce при установке
            SequentialAnimation on scale {
                id: dropBounce
                running: false
                PropertyAnimation {
                    to: 1.01
                    duration: 100
                    easing.type: Easing.OutQuad
                }
                PropertyAnimation {
                    to: 1.0
                    duration: 150
                    easing.type: Easing.OutBounce
                }
            }

            Drag.active: dragArea.drag.active
            Drag.hotSpot.x: width / 2
            Drag.hotSpot.y: height / 2

            MouseArea {
                id: dragArea
                anchors.fill: parent
                drag.target: parent

                onPressed: {
                    cardRoot.startX = cardRoot.x
                    cardRoot.startY = cardRoot.y
                    cardRoot.startIndex = index
                    cardRoot.isDragging = true
                    cardRoot.z = 1000
                    cardRoot.scale = 1.05
                }

                onPositionChanged: {
                    if (!cardRoot.isDragging)
                        return

                    // Вычисляем предполагаемый индекс
                    const gridX = Math.max(
                                    0, Math.min(
                                        cardRoot.gridRef.columns - 1,
                                        Math.round(
                                            cardRoot.x / (cardRoot.gridRef.cellWidth
                                                          + cardRoot.gridRef.spacing))))
                    const gridY = Math.max(
                                    0, Math.min(
                                        Math.ceil(
                                            repeatRoot.count / cardRoot.gridRef.columns) - 1,
                                        Math.round(
                                            cardRoot.y / (cardRoot.gridRef.cellHeight
                                                          + cardRoot.gridRef.spacing))))
                    const hoverIndex = Math.max(
                                         0, Math.min(
                                             repeatRoot.count - 1,
                                             gridY * cardRoot.gridRef.columns + gridX))

                    if (hoverIndex !== cardRoot.hoverIndex) {
                        cardRoot.hoverIndex = hoverIndex
                        // визуальный свап
                        for (var i = 0; i < repeatRoot.count; i++) {
                            const item = repeatRoot.itemAt(i)
                            if (!item)
                                continue
                            if (item === cardRoot)
                                continue

                            if (i > cardRoot.startIndex && i <= hoverIndex)
                                item.displayIndex = i - 1
                            else if (i < cardRoot.startIndex && i >= hoverIndex)
                                item.displayIndex = i + 1
                            else
                                item.displayIndex = i
                        }
                    }
                }

                onReleased: {
                    cardRoot.isDragging = false
                    cardRoot.z = 0
                    cardRoot.scale = 1.0

                    const newIndex = cardRoot.hoverIndex
                    if (newIndex !== cardRoot.startIndex) {
                        const arr = root.videoFiles.slice()
                        arr.splice(newIndex, 0,
                                   arr.splice(cardRoot.startIndex, 1)[0])
                        root.videoFiles = arr
                    }

                    // сброс временных индексов
                    for (var i = 0; i < repeatRoot.count; i++) {
                        const item = repeatRoot.itemAt(i)
                        if (item)
                            item.displayIndex = i
                    }

                    backAnimation.start()
                }

                onCanceled: {
                    cardRoot.isDragging = false
                    cardRoot.z = 0
                    cardRoot.scale = 1.0
                    backAnimation.start()
                }
            }

            ParallelAnimation {
                id: backAnimation
                NumberAnimation {
                    target: cardRoot
                    property: "x"
                    to: gridPos(index).x
                    duration: 200
                    easing.type: Easing.OutQuad
                }
                NumberAnimation {
                    target: cardRoot
                    property: "y"
                    to: gridPos(index).y
                    duration: 200
                    easing.type: Easing.OutQuad
                }
                ScriptAction {
                    script: dropBounce.start()
                }
            }

            Rectangle {
                anchors.fill: parent
                radius: 12
                color: palette.dark
                opacity: cardRoot.isDragging ? 0.85 : 1.0
                scale: cardRoot.scale

                Column {
                    anchors.fill: parent
                    anchors.margins: 5
                    spacing: 5

                    VideoThumbnail {
                        height: parent.height - 25
                        width: parent.width
                        source: modelData
                    }

                    Text {
                        width: parent.width
                        color: palette.text
                        text: modelData.toString().split('/').pop() || "Unknown"
                        font.pointSize: 9
                        elide: Text.ElideMiddle
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }

            Rectangle {
                anchors.fill: parent
                radius: 12
                border.color: palette.highlight
                border.width: 2
                color: "transparent"
                visible: cardRoot.isDragging
            }
        }

        Component.onCompleted: {
            for (var i = 0; i < repeatRoot.count; ++i) {
                var item = repeatRoot.itemAt(i)
                item.gridRef = filesGrid
            }
        }
    }
}
