import QtQuick
import QtQuick.Layouts

MouseArea {
    id: root

    signal toggleRequested()

    property date now: new Date()
    property date day: new Date()
    required property QtObject config

    Layout.preferredWidth: layoutLoader.implicitWidth + 8
    Layout.minimumWidth: 40
    cursorShape: Qt.PointingHandCursor
    onClicked: root.toggleRequested()

    Loader {
        id: layoutLoader
        anchors.centerIn: parent
        sourceComponent: root.config.layoutPosition === 2 ? rowLayoutComponent : columnLayoutComponent
    }

    Component {
        id: columnLayoutComponent

        ColumnLayout {
            spacing: 0

            ClockPanelLabel {
                Layout.fillWidth: true
                fontSize: root.config.timeFontSize
                config: root.config
                textSource: Qt.locale().toString(root.now, root.config.timeFormat)
                visible: root.config.layoutPosition === 0 || !root.config.showDate
            }

            ClockPanelLabel {
                Layout.fillWidth: true
                fontSize: root.config.dateFontSize
                config: root.config
                textSource: Qt.locale().toString(root.day, root.config.dateFormat)
                visible: root.config.layoutPosition === 1 && root.config.showDate
            }

            ClockPanelLabel {
                Layout.fillWidth: true
                fontSize: root.config.timeFontSize
                config: root.config
                textSource: Qt.locale().toString(root.now, root.config.timeFormat)
                visible: root.config.layoutPosition === 1 && root.config.showDate
            }

            ClockPanelLabel {
                Layout.fillWidth: true
                fontSize: root.config.dateFontSize
                config: root.config
                textSource: Qt.locale().toString(root.day, root.config.dateFormat)
                visible: root.config.layoutPosition === 0 && root.config.showDate
            }
        }
    }

    Component {
        id: rowLayoutComponent

        RowLayout {
            spacing: 4

            Repeater {
                model: 2

                ClockPanelLabel {
                    required property int index

                    readonly property bool isDate: root.config.dateFirst ? index === 0 : index === 1

                    fontSize: isDate ? root.config.dateFontSize : root.config.timeFontSize
                    config: root.config
                    textSource: isDate
                                ? Qt.locale().toString(root.day, root.config.dateFormat)
                                : Qt.locale().toString(root.now, root.config.timeFormat)
                    visible: !isDate || root.config.showDate
                }
            }
        }
    }
}
