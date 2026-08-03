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
        sourceComponent: root.config.layoutPosition === 1 ? rowLayoutComponent
                      : root.config.layoutPosition === 2 ? stackedTimeComponent
                      : columnLayoutComponent
    }

    Component {
        id: columnLayoutComponent

        ColumnLayout {
            spacing: root.config.dateTimeSpacing

            Repeater {
                model: 2

                ClockPanelLabel {
                    required property int index

                    readonly property bool isDate: root.config.dateAbove ? index === 0 : index === 1

                    fillWidth: true
                    fontSize: isDate ? root.config.dateFontSize : root.config.timeFontSize
                    config: root.config
                    textSource: isDate ? root.textResolver.fullDateText() : root.textResolver.fullTimeText()
                    visible: !isDate || root.config.showDate
                }
            }
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
                    config: root.config
                    textSource: root.textResolver.hourText()
                }

                ClockPanelLabel {
                    Layout.fillWidth: true
                    fontSize: root.config.timeFontSize
                    config: root.config
                    textSource: root.textResolver.minuteText()
                }

                ClockPanelLabel {
                    Layout.fillWidth: true
                    fontSize: root.config.timeFontSize
                    config: root.config
                    textSource: root.textResolver.secondText()
                    visible: root.textResolver.timeHasSeconds()
                }

                ClockPanelLabel {
                    Layout.fillWidth: true
                    fontSize: root.config.ampmFontSize
                    config: root.config
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
            config: root.config
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
                config: root.config
                textSource: root.textResolver.dateMainText()
            }

            ClockPanelLabel {
                Layout.fillWidth: true
                fontSize: root.config.dateFontSize
                config: root.config
                textSource: root.textResolver.dateMonthText()
                visible: root.textResolver.dateMonthText() !== ""
            }
        }
    }

    Component {
        id: rowLayoutComponent

        RowLayout {
            spacing: root.config.dateTimeSpacing

            Repeater {
                model: 2

                ClockPanelLabel {
                    required property int index

                    readonly property bool isDate: root.config.dateFirst ? index === 0 : index === 1

                    fontSize: isDate ? root.config.dateFontSize : root.config.timeFontSize
                    config: root.config
                    textSource: isDate ? root.textResolver.fullDateText() : root.textResolver.fullTimeText()
                    visible: !isDate || root.config.showDate
                }
            }
        }
    }
}
