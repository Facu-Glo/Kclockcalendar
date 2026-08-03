import QtQuick
import QtQuick.Layouts
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid

MouseArea {
    id: root

    signal toggleRequested()

    property date now: new Date()
    property date day: new Date()
    required property QtObject config

    readonly property bool inVerticalPanel: Plasmoid.formFactor === PlasmaCore.Types.Vertical

    Layout.fillWidth: inVerticalPanel
    Layout.fillHeight: !inVerticalPanel
    Layout.minimumWidth: inVerticalPanel ? 0 : layoutLoader.implicitWidth
    Layout.maximumWidth: inVerticalPanel ? -1 : layoutLoader.implicitWidth
    Layout.minimumHeight: inVerticalPanel ? layoutLoader.implicitHeight : 0
    Layout.maximumHeight: inVerticalPanel ? layoutLoader.implicitHeight : -1
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

    function splitDateFormat() {
        const f = root.config.dateFormat
        if (f.includes("MMMM")) {
            const idx = f.indexOf("MMMM")
            return { before: f.slice(0, idx), after: f.slice(idx + 4), month: "MMMM" }
        }
        if (f.includes("MMM")) {
            const idx = f.indexOf("MMM")
            return { before: f.slice(0, idx), after: f.slice(idx + 3), month: "MMM" }
        }
        return { before: f, after: "", month: "" }
    }

    function dateMainText() {
        const seg = splitDateFormat()
        if (!seg.month) return Qt.locale().toString(root.day, root.config.dateFormat)
        if (seg.before.trim() === "") return Qt.locale().toString(root.day, seg.after).trim()
        return Qt.locale().toString(root.day, seg.before).trim()
    }

    function dateMonthText() {
        const seg = splitDateFormat()
        if (!seg.month) return ""
        const month = Qt.locale().toString(root.day, seg.month).trim()
        if (seg.before.trim() === "") return month
        const tail = Qt.locale().toString(root.day, seg.after).trim()
        return [month, tail].filter(s => s !== "").join(" ")
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

            Loader {
                Layout.fillWidth: true
                active: root.config.showDate && root.config.dateAbove
                sourceComponent: root.config.dateMonthBelow ? stackedDateComponent : mainDateComponent
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

            Loader {
                Layout.fillWidth: true
                active: root.config.showDate && !root.config.dateAbove
                sourceComponent: root.config.dateMonthBelow ? stackedDateComponent : mainDateComponent
            }
        }
    }

    Component {
        id: mainDateComponent

        ClockPanelLabel {
            fontSize: root.config.dateFontSize
            config: root.config
            textSource: Qt.locale().toString(root.day, root.config.dateFormat)
        }
    }

    Component {
        id: stackedDateComponent

        ColumnLayout {
            spacing: 0

            ClockPanelLabel {
                Layout.fillWidth: true
                fontSize: root.config.dateFontSize
                config: root.config
                textSource: root.dateMainText()
            }

            ClockPanelLabel {
                Layout.fillWidth: true
                fontSize: root.config.dateFontSize
                config: root.config
                textSource: root.dateMonthText()
                visible: root.dateMonthText() !== ""
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
