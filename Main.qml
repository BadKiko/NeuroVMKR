import QtQuick
import QtQuick.Controls 2.12

ApplicationWindow {
    width: 640
    height: 480
    visible: true

    Loader {
            id: windowLoader
            anchors.fill: parent
            active: false // Start with no window loaded
        }

    StackView {
        id: stack
        anchors.fill: parent
        initialItem: FileLoadPage {}  // Страница загрузки файлов
    }
}
