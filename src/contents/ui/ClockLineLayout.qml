import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

GridLayout {
    id: root

    property bool isRow: false
    property bool dateIsFirst: false
    property bool showDate: true
    property int spacing: 0
    property int dateFontSize: 10
    property int timeFontSize: 12
    property font labelFont: Qt.application.font
    property color labelColor: Kirigami.Theme.textColor
    property int hAlignment: Text.AlignHCenter
    property string timeText: ""
    property string dateText: ""

    columns: root.isRow ? 2 : 1
    columnSpacing: root.spacing
    rowSpacing: root.spacing

    Repeater {
        model: 2

        ClockPanelLabel {
            required property int index

            readonly property bool isDate: root.dateIsFirst ? index === 0 : index === 1

            visible: root.showDate || !isDate
            fillWidth: true
            fontSize: isDate ? root.dateFontSize : root.timeFontSize
            labelFont: root.labelFont
            labelColor: root.labelColor
            hAlignment: root.hAlignment
            textSource: isDate ? root.dateText : root.timeText
        }
    }
}
