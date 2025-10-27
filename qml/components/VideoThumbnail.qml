import QtQuick

// Простой компонент для создания миниатюр видео с использованием C++ провайдера
Item {
    id: root
    property string source: ""
    property int thumbnailWidth: 160
    property int thumbnailHeight: 120

    // Сигнал испускается когда миниатюра готова
    signal thumbnailReady(var thumbnailImage)

    width: thumbnailWidth
    height: thumbnailHeight

    // Изображение для отображения миниатюры
    Image {
        id: thumbnailImage
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        cache: false

        // Используем C++ провайдер для получения миниатюры
        source: root.source ? "image://videoThumbnail/" + encodeURIComponent(root.source) : ""

        onStatusChanged: {
            if (status === Image.Ready) {
                console.log("Thumbnail loaded successfully:", root.source)
                root.thumbnailReady(thumbnailImage)
            } else if (status === Image.Error) {
                console.warn("Failed to load thumbnail for:", root.source)
                // Показываем placeholder при ошибке
                placeholder.visible = true
            }
        }
    }

    // Placeholder для ошибок
    Rectangle {
        id: placeholder
        anchors.fill: parent
        color: "#333333"
        visible: false

        Text {
            anchors.centerIn: parent
            text: "📹"
            font.pointSize: 24
            color: "#666666"
        }
    }

    // Создаем миниатюру при изменении источника
    onSourceChanged: {
        console.log("Video source changed to:", source)
        placeholder.visible = false
        if (source) {
            // Обновляем изображение, что вызовет запрос к провайдеру
            thumbnailImage.source = "image://videoThumbnail/" + encodeURIComponent(source)
        }
    }
}
