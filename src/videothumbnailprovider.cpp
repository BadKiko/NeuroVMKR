#include "videothumbnailprovider.h"
#include <QMediaPlayer>
#include <QVideoFrame>
#include <QImage>
#include <QVideoSink>
#include <QTimer>
#include <QEventLoop>
#include <QDebug>
#include <QPainter>
#include <QFont>

class VideoFrameGrabber : public QObject
{
    Q_OBJECT
public:
    VideoFrameGrabber(const QString &videoPath, const QSize &size, QObject *parent = nullptr)
        : QObject(parent), m_requestedSize(size)
    {
        m_mediaPlayer = new QMediaPlayer(this);
        m_videoSink = new QVideoSink(this);

        m_mediaPlayer->setVideoSink(m_videoSink);
        m_mediaPlayer->setSource(QUrl::fromLocalFile(videoPath));

        connect(m_videoSink, &QVideoSink::videoFrameChanged, this, &VideoFrameGrabber::onFrameChanged);
        connect(m_mediaPlayer, &QMediaPlayer::errorOccurred, this, &VideoFrameGrabber::onError);
    }

    QImage grabFrame()
    {
        QEventLoop loop;
        connect(this, &VideoFrameGrabber::frameReady, &loop, &QEventLoop::quit);
        connect(this, &VideoFrameGrabber::errorOccurred, &loop, &QEventLoop::quit);

        // Запускаем воспроизведение
        m_mediaPlayer->play();

        // Ждем получения кадра или ошибки (максимум 5 секунд)
        QTimer::singleShot(5000, &loop, &QEventLoop::quit);
        loop.exec();

        return m_image;
    }

private slots:
    void onFrameChanged(const QVideoFrame &frame)
    {
        if (frame.isValid()) {
            m_image = frame.toImage();
            if (!m_requestedSize.isEmpty()) {
                m_image = m_image.scaled(m_requestedSize, Qt::KeepAspectRatio, Qt::SmoothTransformation);
            }
            m_mediaPlayer->stop();
            emit frameReady();
        }
    }

    void onError(QMediaPlayer::Error error, const QString &errorString)
    {
        qWarning() << "Video thumbnail error:" << error << errorString;
        m_mediaPlayer->stop();
        emit errorOccurred();
    }

signals:
    void frameReady();
    void errorOccurred();

private:
    QMediaPlayer *m_mediaPlayer;
    QVideoSink *m_videoSink;
    QImage m_image;
    QSize m_requestedSize;
};

#include "videothumbnailprovider.moc"

VideoThumbnailProvider::VideoThumbnailProvider()
    : QQuickImageProvider(QQuickImageProvider::Image)
{
}

VideoThumbnailProvider::~VideoThumbnailProvider()
{
}

QImage VideoThumbnailProvider::requestImage(const QString &id, QSize *size, const QSize &requestedSize)
{
    qDebug() << "Requesting thumbnail for:" << id;

    // ID содержит путь к видео файлу
    QString videoPath = QUrl::fromPercentEncoding(id.toUtf8());

    QImage thumbnail = extractFrameFromVideo(videoPath, requestedSize);

    if (size) {
        *size = thumbnail.size();
    }

    return thumbnail;
}

QImage VideoThumbnailProvider::extractFrameFromVideo(const QString &videoPath, const QSize &requestedSize)
{
    if (videoPath.isEmpty()) {
        return QImage();
    }

    VideoFrameGrabber grabber(videoPath, requestedSize);

    // Выполняем в отдельном потоке для избежания блокировки UI
    QImage result = grabber.grabFrame();

    if (result.isNull()) {
        // Возвращаем placeholder изображение при ошибке
        result = QImage(requestedSize.isEmpty() ? QSize(160, 120) : requestedSize, QImage::Format_RGB32);
        result.fill(QColor(50, 50, 50)); // Темно-серый цвет

        // Рисуем иконку ошибки
        QPainter painter(&result);
        painter.setPen(QColor(255, 100, 100));
        painter.setFont(QFont("Arial", 24));
        painter.drawText(result.rect(), Qt::AlignCenter, "❌");
    }

    return result;
}
