import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.extras as PlasmaExtras
import org.kde.plasma.workspace.calendar as PlasmaCalendar

PlasmoidItem {
    id: root

    toolTipMainText: Qt.locale().toString(root.now, root.config.timeFormat)
    toolTipSubText: Qt.locale().toString(root.day, "dddd d MMMM yyyy")

    preferredRepresentation: compactRepresentation

    property QtObject config: ConfigResolver {}
    property Item clock: ClockState {
        timeFormat: root.config.timeFormat
        popupTimeFormat: root.config.popupTimeFormat
        expanded: root.expanded
    }

    property date now: clock.now
    property date day: clock.day
    property date currentDate: clock.day
    property date today: clock.day
    property int currentView: 0

    compactRepresentation: PanelClock {
        now: root.now
        day: root.day
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
            root.currentDate = root.today
            root.currentView = 0
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
                now: root.now
                day: root.day
                monthTitle: calendarBackend.monthName + " " + calendarBackend.year
                config: root.config
                onMonthTitleClicked: root.currentView = root.currentView === 0 ? 1 : 0
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
                    visible: root.currentView === 0
                    backend: calendarBackend
                    eventPluginsManager: eventPluginsManager

                    delegate: DaysCalendar {
                        required property int index

                        dateMatchingPrecision: PlasmaCalendar.Calendar.MatchYearMonthAndDay
                        columns: calendarBackend.days
                        rows: calendarBackend.weeks
                        width: monthView.width
                        height: monthView.height
                        dayOfWeekHeaderModel: calendarBackend.days
                        todayDate: root.today
                        selectedDate: root.currentDate
                        highlightColor: root.config.highlightColor

                        backend: index === 0 ? monthView.previousCalendar : (index === 2 ? monthView.nextCalendar : calendarBackend)
                        gridModel: index === 0 ? monthView.previousModel : (index === 2 ? monthView.nextModel : calendarBackend.daysModel)

                        onDateSelected: (d) => {
                            root.currentDate = d
                        }
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
