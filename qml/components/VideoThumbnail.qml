import QtQuick
import QtQuick.Controls
import QtMultimedia

// Простой компонент для создания миниатюр видео
Item {
    id: root
    property string source: ""
    property int thumbnailWidth: 160
    property int thumbnailHeight: 120

    // Сигнал испускается когда миниатюра готова
    signal thumbnailReady(var thumbnailImage)

    width: thumbnailWidth
    height: thumbnailHeight

    // Видео для создания миниатюры
    Video {
        id: videoPlayer
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
        }
    }

    // Функция для создания миниатюры
    function createThumbnail() {
        if (root.source) {
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
