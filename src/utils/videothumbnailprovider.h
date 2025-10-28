#pragma once
#include <QQuickImageProvider>
#include <QImage>
#include <QString>

class VideoThumbnailProvider : public QQuickImageProvider
{
public:
    VideoThumbnailProvider();
    ~VideoThumbnailProvider();

    QImage requestImage(const QString &id, QSize *size, const QSize &requestedSize) override;
private:
    QImage roundImage(QImage frame, int roundPixels);
};
