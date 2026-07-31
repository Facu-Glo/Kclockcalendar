import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.extras as PlasmaExtras
import org.kde.plasma.workspace.calendar as PlasmaCalendar

PlasmoidItem {
    id: root

    preferredRepresentation: compactRepresentation

    property QtObject config: ConfigResolver {}
    property Item clock: ClockState {
        showSeconds: root.config.showSeconds
        showPopupSeconds: root.config.showPopupSeconds
        expanded: root.expanded
    }

    property date now: clock.now
    property date day: clock.day
    property date currentDate: clock.day
    property date today: clock.day
    property int currentView: 0 // 0 = days, 1 = months

    compactRepresentation: PanelClock {
        now: root.now
        day: root.day
        config: root.config
        onToggleRequested: root.expanded = !root.expanded
    }

    fullRepresentation: PlasmaExtras.Representation {
        Layout.preferredWidth: 340
        Layout.preferredHeight: 460

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
                    calendarBackend.resetToToday()
                    root.currentDate = root.today
                    root.currentView = 0
                }
            }
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 14

            PopupHeader {
                Layout.fillWidth: true
                now: root.now
                day: root.day
                monthTitle: calendarBackend.monthName + " " + calendarBackend.year
                config: root.config
                onMonthTitleClicked: root.currentView = root.currentView === 0 ? 1 : 0
                onPreviousMonth: calendarBackend.previousMonth()
                onNextMonth: calendarBackend.nextMonth()
            }

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                DaysCalendar {
                    anchors.fill: parent
                    visible: root.currentView === 0

                    columns: calendarBackend.days
                    rows: calendarBackend.weeks
                    dateMatchingPrecision: PlasmaCalendar.Calendar.MatchYearMonthAndDay
                    dayOfWeekHeaderModel: calendarBackend.days
                    todayDate: root.today
                    selectedDate: root.currentDate
                    highlightShape: root.config.dayHighlightShape
                    highlightColor: root.config.highlightColor

                    backend: calendarBackend
                    gridModel: calendarBackend.daysModel

                    onDateSelected: (d) => {
                        root.currentDate = d
                    }
                }

                MonthsCalendar {
                    anchors.fill: parent
                    visible: root.currentView === 1
                    backend: calendarBackend
                    highlightColor: root.config.highlightColor
                    onMonthSelected: (month) => {
                        calendarBackend.goToMonth(month)
                        root.currentView = 0
                    }
                }
            }
        }
    }
}
