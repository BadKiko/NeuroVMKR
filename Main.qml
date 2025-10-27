import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    width: 640
    height: 480
    visible: true
    title: "NeuroVMKR"

    StackView {
        id: navStack
        anchors.fill: parent
        initialItem: FileLoadPage {}
    }

    // Настройка черно-белой-серой темы
    palette.window: "#222222" // Основной фон окна (черный)
    palette.accent: "#ffffff"
    palette.windowText: "#ffffff" // Цвет текста на фоне окна (белый)
    palette.base: "#1a1a1a" // Фон для полей ввода (темно-серый)
    palette.text: "#ffffff" // Основной цвет текста (белый)
    palette.button: "#333333" // Фон кнопок (серый)
    palette.buttonText: "#ffffff" // Цвет текста на кнопках (белый)
    palette.highlight: "#F5F1DC" // Цвет выделения (светло-серый)
    palette.highlightedText: "#000000" // Цвет текста в выделении (черный)
    palette.light: "#ffffff" // Светлый цвет для 3D эффектов
    palette.midlight: "#333333" // Средне-светлый цвет
    palette.mid: "#666666" // Средний цвет
    palette.dark: "#1a1a1a" // Темный цвет для 3D эффектов
    palette.shadow: "#000000" // Цвет теней
}
