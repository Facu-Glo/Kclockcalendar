import QtQuick
import QtQuick.Layouts
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid

MouseArea {
    id: root

    signal toggleRequested()

    property date now: new Date()
    property date today: new Date()
    required property QtObject config

    readonly property bool inVerticalPanel: Plasmoid.formFactor === PlasmaCore.Types.Vertical

    readonly property font labelFont: root.config.resolvedFont
    readonly property color labelColor: root.config.textColor
    readonly property int hAlignment: root.config.panelHAlignment

    Layout.fillWidth: inVerticalPanel
    Layout.fillHeight: !inVerticalPanel
    Layout.minimumWidth: inVerticalPanel ? 0 : layoutLoader.implicitWidth
    Layout.maximumWidth: inVerticalPanel ? -1 : layoutLoader.implicitWidth
    Layout.minimumHeight: inVerticalPanel ? layoutLoader.implicitHeight : 0
    Layout.maximumHeight: inVerticalPanel ? layoutLoader.implicitHeight : -1
    onClicked: root.toggleRequested()

    property QtObject textResolver: ClockTextResolver {
        now: root.now
        day: root.today
        timeFormat: root.config.timeFormat
        dateFormat: root.config.dateFormat
    }

    Loader {
        id: layoutLoader
        anchors.centerIn: parent
        sourceComponent: root.config.layoutPosition === "stacked" ? stackedTimeComponent : lineLayoutComponent
    }

    Component {
        id: lineLayoutComponent

        ClockLineLayout {
            isRow: root.config.layoutPosition === "horizontal"
            dateIsFirst: root.config.layoutPosition === "horizontal" ? root.config.dateFirst : root.config.dateAbove
            showDate: root.config.showDate
            spacing: root.config.dateTimeSpacing
            dateFontSize: root.config.dateFontSize
            timeFontSize: root.config.timeFontSize
            labelFont: root.labelFont
            labelColor: root.labelColor
            hAlignment: root.hAlignment
            timeText: root.textResolver.fullTimeText()
            dateText: root.textResolver.fullDateText()
        }
    }

    Component {
        id: stackedTimeComponent

        ColumnLayout {
            spacing: root.config.dateTimeSpacing

            Loader {
                Layout.fillWidth: true
                active: root.config.showDate && root.config.dateAbove
                sourceComponent: root.config.dateMonthBelow ? stackedDateComponent : mainDateComponent
                visible: active
                Layout.preferredHeight: active ? implicitHeight : 0
                Layout.preferredWidth: active ? implicitWidth : 0
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 0

                ClockPanelLabel {
                    Layout.fillWidth: true
                    fontSize: root.config.timeFontSize
                    labelFont: root.labelFont
                    labelColor: root.labelColor
                    hAlignment: root.hAlignment
                    textSource: root.textResolver.hourText()
                }

                ClockPanelLabel {
                    Layout.fillWidth: true
                    fontSize: root.config.timeFontSize
                    labelFont: root.labelFont
                    labelColor: root.labelColor
                    hAlignment: root.hAlignment
                    textSource: root.textResolver.minuteText()
                }

                ClockPanelLabel {
                    Layout.fillWidth: true
                    fontSize: root.config.timeFontSize
                    labelFont: root.labelFont
                    labelColor: root.labelColor
                    hAlignment: root.hAlignment
                    textSource: root.textResolver.secondText()
                    visible: root.textResolver.timeHasSeconds()
                }

                ClockPanelLabel {
                    Layout.fillWidth: true
                    fontSize: root.config.ampmFontSize
                    labelFont: root.labelFont
                    labelColor: root.labelColor
                    hAlignment: root.hAlignment
                    textSource: root.textResolver.ampmText()
                    visible: root.textResolver.ampmText() !== ""
                }
            }

            Loader {
                Layout.fillWidth: true
                active: root.config.showDate && !root.config.dateAbove
                sourceComponent: root.config.dateMonthBelow ? stackedDateComponent : mainDateComponent
                visible: active
                Layout.preferredHeight: active ? implicitHeight : 0
                Layout.preferredWidth: active ? implicitWidth : 0
            }
        }
    }

    Component {
        id: mainDateComponent

        ClockPanelLabel {
            fontSize: root.config.dateFontSize
            labelFont: root.labelFont
            labelColor: root.labelColor
            hAlignment: root.hAlignment
            textSource: root.textResolver.fullDateText()
        }
    }

    Component {
        id: stackedDateComponent

        ColumnLayout {
            spacing: 0

            ClockPanelLabel {
                Layout.fillWidth: true
                fontSize: root.config.dateFontSize
                labelFont: root.labelFont
                labelColor: root.labelColor
                hAlignment: root.hAlignment
                textSource: root.textResolver.dateMainText()
            }

            ClockPanelLabel {
                Layout.fillWidth: true
                fontSize: root.config.dateFontSize
                labelFont: root.labelFont
                labelColor: root.labelColor
                hAlignment: root.hAlignment
                textSource: root.textResolver.dateMonthText()
                visible: root.textResolver.dateMonthText() !== ""
            }
        }
    }
}
