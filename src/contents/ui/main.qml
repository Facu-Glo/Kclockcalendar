import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.extras as PlasmaExtras
import org.kde.plasma.workspace.calendar as PlasmaCalendar

PlasmoidItem {
    id: root

    toolTipMainText: Qt.locale().toString(root.now, root.config.timeFormat)
    toolTipSubText: Qt.locale().toString(root.today, "dddd d MMMM yyyy")

    preferredRepresentation: compactRepresentation

    property QtObject config: ConfigResolver {}
    property Item clock: ClockState {
        timeFormat: root.config.timeFormat
        popupTimeFormat: root.config.popupTimeFormat
        expanded: root.expanded
    }

    property date now: clock.now
    property date today: clock.today
    property date selectedDate: clock.today
    property bool showingYear: false

    compactRepresentation: PanelClock {
        now: root.now
        today: root.today
        config: root.config
        onToggleRequested: root.expanded = !root.expanded
    }

    fullRepresentation: PlasmaExtras.Representation {
        Layout.preferredWidth: 340
        Layout.preferredHeight: 460
        Layout.minimumWidth: 340
        Layout.minimumHeight: 460

        function goToToday() {
            calendarBackend.resetToToday()
            root.selectedDate = root.today
            root.showingYear = false
            monthView.resetViewPosition()
        }

        PlasmaCalendar.Calendar {
            id: calendarBackend
            days: 7
            weeks: 6
            firstDayOfWeek: root.config.firstDayOfWeek || Qt.locale().firstDayOfWeek
            today: root.today
        }

        Connections {
            target: root
            function onExpandedChanged() {
                if (root.expanded) {
                    goToToday()
                }
            }
        }

        PlasmaCalendar.EventPluginsManager {
            id: eventPluginsManager
            enabledPlugins: root.config.showHolidays ? ["holidaysevents"] : []
        }

        Component.onCompleted: {
            calendarBackend.daysModel.setPluginsManager(eventPluginsManager)
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            anchors.topMargin: 0
            spacing: 14

            PopupHeader {
                Layout.fillWidth: true
                monthTitle: calendarBackend.monthName + " " + calendarBackend.year
                clockText: Qt.locale().toString(root.now, root.config.popupTimeFormat)
                dateText: Qt.locale().toString(root.today, root.config.popupDateFormat)
                clockFontSize: root.config.bigClockFontSize
                labelColor: root.config.textColor
                onMonthTitleClicked: root.showingYear = !root.showingYear
                onPreviousMonth: monthView.goToPreviousMonth()
                onNextMonth: monthView.goToNextMonth()
                onTodayClicked: goToToday()
            }

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true

                MonthSlider {
                    id: monthView
                    anchors.fill: parent
                    visible: root.showingYear === false
                    backend: calendarBackend
                    eventPluginsManager: eventPluginsManager

                    delegate: DaysCalendar {
                        required property int index

                        dateMatchingPrecision: PlasmaCalendar.Calendar.MatchYearMonthAndDay
                        columns: calendarBackend.days
                        rows: calendarBackend.weeks
                        width: monthView.width
                        height: monthView.height
                        todayDate: root.today
                        selectedDate: root.selectedDate
                        highlightColor: root.config.highlightColor

                        backend: index === 0 ? monthView.previousCalendar : (index === 2 ? monthView.nextCalendar : calendarBackend)

                        onDateSelected: (d) => {
                            root.selectedDate = d
                        }
                    }
                }

                MonthsCalendar {
                    anchors.fill: parent
                    visible: root.showingYear
                    backend: calendarBackend
                    highlightColor: root.config.highlightColor
                    onMonthSelected: (month) => {
                        calendarBackend.goToMonth(month)
                        root.showingYear = false
                    }
                }
            }
        }
    }
}
