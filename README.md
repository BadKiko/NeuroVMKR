# NeuroVMKR - Обработка и анализ видеофайлов

## Видео миниатюры в QML

В проекте реализовано два простых способа создания миниатюр видео в QML:

### Способ 1: Video элемент для preview (самый простой)

В `FileMovePage.qml` используется обычный Video элемент для показа первого кадра видео:

```qml
Video {
    id: videoPreview
    width: parent.width - 16
    height: 100
    source: modelData
    autoPlay: false
    loops: MediaPlayer.Infinite

    // Показываем первый кадр и останавливаемся
    onPlaying: {
        seek(0) // Переходим к началу
        pause() // Останавливаем на первом кадре
    }
}
```

### Способ 2: VideoThumbnail компонент

Создан компонент `VideoThumbnail.qml` для создания миниатюр с возможностью захвата кадров:

```qml
VideoThumbnail {
    source: "path/to/video.mp4"
    thumbnailWidth: 160
    thumbnailHeight: 120

    onThumbnailReady: (thumbnailImage) => {
        // thumbnailImage - это QImage с миниатюрой
        console.log("Миниатюра готова:", thumbnailImage.width, "x", thumbnailImage.height)
    }
}
```

## Как использовать VideoThumbnail компонент

1. **Простое использование:**
   ```qml
   VideoThumbnail {
       source: "/path/to/video.mp4"
       onThumbnailReady: (image) => {
           thumbnailImage.source = image
       }
   }
   ```

2. **В ListView:**
   ```qml
   ListView {
       model: videoFiles
       delegate: Rectangle {
           VideoThumbnail {
               source: modelData
               onThumbnailReady: (image) => {
                   thumbnail.source = image
               }
           }
       }
   }
   ```

## Структура проекта

- `qml/Main.qml` - Главное окно приложения
- `qml/FileLoadPage.qml` - Загрузка файлов
- `qml/FileMovePage.qml` - Показ миниатюр видео
- `qml/components/VideoThumbnail.qml` - Компонент для создания миниатюр
- `qml/VideoThumbnailExample.qml` - Примеры использования
- `src/utils/videothumbnailprovider.*` - C++ классы для работы с видео (оставлены для совместимости)

## Сборка

```bash
mkdir build
cd build
cmake ..
make
```

## Запуск

```bash
./appNeuroVMKR
```

## Особенности

- **Автоматическое создание миниатюр** при изменении источника видео
- **Кеширование** миниатюр для лучшей производительности
- **Обработка ошибок** загрузки видео
- **Асинхронная** загрузка без блокировки UI
