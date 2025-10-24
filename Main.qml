import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    width: 640
    height: 480
    visible: true
    title: "NeuroVMKR"

    StackView {
        id: stack
        anchors.fill: parent
        initialItem: FileLoadPage {}
    }


    // Настройка базовой палитры
    palette.window: "white"
    palette.button: "lightgray"
    palette.text: "red"
}
