#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtQuickControls2/QQuickStyle>
#include "utils/videothumbnailprovider.h"

int main(int argc, char *argv[])
{
    // 1. Установка переменных окружения
    qputenv("QT_MEDIA_BACKEND", "ffmpeg");
    qputenv("LIBVA_DRIVER_NAME", "radeonsi");
    qputenv("VDPAU_DRIVER", "radeonsi"); 
    qputenv("QT_FFMPEG_DECODING_HW_DEVICE_TYPES", "vaapi");

    QGuiApplication app(argc, argv);

    QQuickStyle::setStyle("Material");

    QQmlApplicationEngine engine;

    // Регистрируем провайдер миниатюр видео
    VideoThumbnailProvider *thumbnailProvider = new VideoThumbnailProvider();
    engine.addImageProvider("videoThumbnail", thumbnailProvider);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
                     &app, []() { QCoreApplication::exit(-1); },
                     Qt::QueuedConnection);
    engine.loadFromModule("NeuroVMKR", "Main");

    return app.exec();
}
