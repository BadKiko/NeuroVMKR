import QtQuick
import QtMultimedia

// Простой компонент для создания миниатюр видео
Item {
    id: root
    property string source: ""

    // Сигнал испускается когда миниатюра готова
    signal thumbnailReady(var thumbnailImage)

    // Видео для создания миниатюры
    Video {
        id: videoPlayer
        anchors.fill: parent
        source: root.source
        autoPlay: false
        visible: false // Не показываем видео, только используем для кадра

        // Когда видео готово к воспроизведению
        onPlaying: {
            // Захватываем первый кадр
            grabToImage(function(result) {
                root.thumbnailReady(result.image)
                videoPlayer.stop()
            })
        }

        // Обработка ошибок
        onErrorOccurred: {
            console.log("Video error:", errorString)
            console.log("Video source:", source)
            console.log("Error code:", error)
        }
    }

    // Функция для создания миниатюры
    function createThumbnail() {
        if (root.source) {
            console.log("Creating thumbnail for:", root.source)
            // Убеждаемся что путь является правильным URL
            if (!root.source.startsWith("file://") && !root.source.startsWith("http")) {
                console.warn("Invalid video source format:", root.source)
                return
            }
            videoPlayer.play()
        }
    }

    // Создаем миниатюру при изменении источника
    onSourceChanged: {
        if (source) {
            createThumbnail()
        }
    }
}
