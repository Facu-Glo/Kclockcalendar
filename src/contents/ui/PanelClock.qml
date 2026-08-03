import QtQuick
import QtQuick.Layouts

MouseArea {
    id: root

    signal toggleRequested()

    property date now: new Date()
    property date day: new Date()
    required property QtObject config

    Layout.preferredWidth: layoutLoader.implicitWidth + 8
    Layout.preferredHeight: layoutLoader.implicitHeight + 4
    Layout.minimumWidth: 40
    Layout.minimumHeight: 20
    onClicked: root.toggleRequested()

    function timeIs12h() {
        const f = root.config.timeFormat
        return f.includes("ap") || f.includes("AP")
    }

    function timeHasSeconds() {
        return root.config.timeFormat.includes("s")
    }

    function hourText() {
        const has12h = timeIs12h()
        const leading = has12h ? root.config.timeFormat.includes("hh") : root.config.timeFormat.includes("HH")
        const fmt = has12h ? (leading ? "hh" : "h") : (leading ? "HH" : "H")
        return Qt.locale().toString(root.now, fmt)
    }

    function minuteText() {
        return Qt.locale().toString(root.now, root.config.timeFormat.includes("mm") ? "mm" : "m")
    }

    function ampmText() {
        if (!timeIs12h()) return ""
        const ap = root.config.timeFormat.includes("ap") ? "ap" : "AP"
        return Qt.locale().toString(root.now, ap)
    }

    function secondText() {
        if (!timeHasSeconds()) return ""
        return Qt.locale().toString(root.now, root.config.timeFormat.includes("ss") ? "ss" : "s")
    }

    Loader {
        id: layoutLoader
        anchors.centerIn: parent
        sourceComponent: root.config.layoutPosition === 1 ? rowLayoutComponent
                      : root.config.layoutPosition === 2 ? stackedTimeComponent
                      : columnLayoutComponent
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
                visible: !root.config.dateAbove || !root.config.showDate
            }

            ClockPanelLabel {
                Layout.fillWidth: true
                fontSize: root.config.dateFontSize
                config: root.config
                textSource: Qt.locale().toString(root.day, root.config.dateFormat)
                visible: root.config.dateAbove && root.config.showDate
            }

            ClockPanelLabel {
                Layout.fillWidth: true
                fontSize: root.config.timeFontSize
                config: root.config
                textSource: Qt.locale().toString(root.now, root.config.timeFormat)
                visible: root.config.dateAbove && root.config.showDate
            }

            ClockPanelLabel {
                Layout.fillWidth: true
                fontSize: root.config.dateFontSize
                config: root.config
                textSource: Qt.locale().toString(root.day, root.config.dateFormat)
                visible: !root.config.dateAbove && root.config.showDate
            }
        }
    }

    Component {
        id: stackedTimeComponent

        ColumnLayout {
            spacing: 0

            ClockPanelLabel {
                Layout.fillWidth: true
                fontSize: root.config.dateFontSize
                config: root.config
                textSource: Qt.locale().toString(root.day, root.config.dateFormat)
                visible: root.config.showDate && root.config.dateAbove
            }

            ClockPanelLabel {
                Layout.fillWidth: true
                fontSize: root.config.timeFontSize
                config: root.config
                textSource: root.hourText()
            }

            ClockPanelLabel {
                Layout.fillWidth: true
                fontSize: root.config.timeFontSize
                config: root.config
                textSource: root.minuteText()
            }

            ClockPanelLabel {
                Layout.fillWidth: true
                fontSize: root.config.timeFontSize
                config: root.config
                textSource: root.secondText()
                visible: root.timeHasSeconds()
            }

            ClockPanelLabel {
                Layout.fillWidth: true
                fontSize: root.config.ampmFontSize
                config: root.config
                textSource: root.ampmText()
                visible: root.ampmText() !== ""
            }

            ClockPanelLabel {
                Layout.fillWidth: true
                fontSize: root.config.dateFontSize
                config: root.config
                textSource: Qt.locale().toString(root.day, root.config.dateFormat)
                visible: root.config.showDate && !root.config.dateAbove
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
