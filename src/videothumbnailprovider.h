#ifndef VIDEOTHUMBNAILPROVIDER_H
#define VIDEOTHUMBNAILPROVIDER_H

#include <QQuickImageProvider>
#include <QObject>
#include <QString>
#include <QImage>

class VideoThumbnailProvider : public QQuickImageProvider
{
public:
    VideoThumbnailProvider();
    ~VideoThumbnailProvider();

    QImage requestImage(const QString &id, QSize *size, const QSize &requestedSize) override;

private:
    QImage extractFrameFromVideo(const QString &videoPath, const QSize &requestedSize);
};

#endif // VIDEOTHUMBNAILPROVIDER_H
