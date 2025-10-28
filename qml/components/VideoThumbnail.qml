import QtQuick

// Простой компонент для создания миниатюр видео с использованием C++ провайдера
Item {
    id: root
    property string source: ""

    // Сигнал испускается когда миниатюра готова
    signal thumbnailReady(var thumbnailImage)

    // Изображение для отображения миниатюры
    Image {
        id: thumbnailImage
        anchors.fill: parent
        // Используем C++ провайдер для получения миниатюры
        source: root.source ? "image://videoThumbnail/" + encodeURIComponent(
                                  root.source) : ""
    }
}
