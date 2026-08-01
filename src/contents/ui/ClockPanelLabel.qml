import QtQuick
import QtQuick.Layouts
import org.kde.plasma.components as PlasmaComponents

PlasmaComponents.Label {
    id: root

    property string textSource: ""
    property int fontSize: 12
    property bool fillWidth: false
    required property QtObject config

    Layout.fillWidth: fillWidth
    Layout.alignment: Qt.AlignHCenter
    font.pixelSize: fontSize
    font.weight: root.config.resolvedFont.weight
    font.family: root.config.resolvedFont.family
    font.italic: root.config.resolvedFont.italic
    color: root.config.textColor
    horizontalAlignment: root.config.panelHAlignment
    text: root.textSource
}
