#include "videothumbnailprovider.h"
#include <QMediaPlayer>
#include <QVideoSink>
#include <QVideoFrame>
#include <QEventLoop>
#include <QPainter>
#include <QPainterPath>

VideoThumbnailProvider::VideoThumbnailProvider()
    : QQuickImageProvider(QQuickImageProvider::Image) {}

VideoThumbnailProvider::~VideoThumbnailProvider() {}

QImage VideoThumbnailProvider::roundImage(QImage frame, int roundPixels)
{
    QImage dest(frame.size(), QImage::Format_ARGB32);
    dest.fill(Qt::transparent);

    QPainterPath clipPath;
    clipPath.addRoundedRect(frame.rect().adjusted(10, 10, -10, -10), roundPixels, roundPixels);

    QPainter p(&dest);
    p.setClipPath(clipPath);
    p.drawImage(0, 0, frame);
    p.end();

    return dest;
}

QImage VideoThumbnailProvider::requestImage(const QString &id, QSize*, const QSize&)
{
    QString videoPath = QUrl::fromPercentEncoding(id.toUtf8());
    if (videoPath.isEmpty())
        return {};

    QMediaPlayer player;
    QVideoSink sink;
    player.setVideoSink(&sink);
    player.setSource(QUrl::fromLocalFile(videoPath));

    QImage frame;
    QEventLoop loop;

    QObject::connect(&sink, &QVideoSink::videoFrameChanged, [&](const QVideoFrame &f){
        if (f.isValid()) {
            frame = f.toImage();
            loop.quit();
        }
    });

    QObject::connect(&player, &QMediaPlayer::errorOccurred, [&](QMediaPlayer::Error, const QString &){
        loop.quit();
    });

    player.play();
    loop.exec();
    player.stop();

    return roundImage(frame, 64);;
}
