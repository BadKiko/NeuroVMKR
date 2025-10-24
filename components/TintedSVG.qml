import QtQuick 2.15
import Qt5Compat.GraphicalEffects

Item {
    id: root
    property url source: ""
    property color tint: "red"
    property real rotationAngle: 0
    width: 64
    height: 64

    Image {
        id: originalImage
        anchors.fill: parent
        source: root.source
        fillMode: Image.PreserveAspectFit
        smooth: true
        transform: Rotation {
            angle: root.rotationAngle
            origin.x: width / 2
            origin.y: height / 2
        }
    }

    ColorOverlay {
        anchors.fill: originalImage
        source: originalImage
        color: root.tint
    }
}
