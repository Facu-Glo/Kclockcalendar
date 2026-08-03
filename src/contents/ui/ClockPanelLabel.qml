import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents

PlasmaComponents.Label {
    id: root

    property string textSource: ""
    property int fontSize: 12
    property bool fillWidth: false
    property font labelFont: Qt.application.font
    property color labelColor: Kirigami.Theme.textColor
    property int hAlignment: Text.AlignHCenter

    Layout.fillWidth: fillWidth
    Layout.alignment: Qt.AlignHCenter
    font.pixelSize: fontSize
    font.weight: root.labelFont.weight
    font.family: root.labelFont.family
    font.italic: root.labelFont.italic
    color: root.labelColor
    horizontalAlignment: root.hAlignment
    text: root.textSource
}
