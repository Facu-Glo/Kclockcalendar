import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
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
        id: fullRep

        Layout.preferredWidth: 340
        Layout.preferredHeight: 460
        Layout.minimumWidth: 340
        Layout.minimumHeight: 460

        PlasmaCalendar.Calendar {
            id: calendarBackend
            days: 7
            weeks: 6
            firstDayOfWeek: root.config.firstDayOfWeek || Qt.locale().firstDayOfWeek
            today: root.today
        }

        PlasmaCalendar.Calendar {
            id: previousCalendar
            days: calendarBackend.days
            weeks: calendarBackend.weeks
            firstDayOfWeek: calendarBackend.firstDayOfWeek
            today: calendarBackend.today
            Component.onCompleted: goToYearAndMonth(fullRep.adjacentYear(-1), fullRep.adjacentMonthNumber(-1))
        }

        PlasmaCalendar.Calendar {
            id: nextCalendar
            days: calendarBackend.days
            weeks: calendarBackend.weeks
            firstDayOfWeek: calendarBackend.firstDayOfWeek
            today: calendarBackend.today
            Component.onCompleted: goToYearAndMonth(fullRep.adjacentYear(1), fullRep.adjacentMonthNumber(1))
        }

        function modulo(a, n) {
            return ((((a - 1) % n) + n) % n) + 1
        }

        function adjacentMonthNumber(offset) {
            return modulo(calendarBackend.month + offset, 12)
        }

        function adjacentYear(offset) {
            const month = adjacentMonthNumber(offset)
            if (offset < 0 && month === 12) return calendarBackend.year - 1
            if (offset > 0 && month === 1) return calendarBackend.year + 1
            return calendarBackend.year
        }

        function updateAdjacentMonths() {
            previousCalendar.goToYearAndMonth(adjacentYear(-1), adjacentMonthNumber(-1))
            nextCalendar.goToYearAndMonth(adjacentYear(1), adjacentMonthNumber(1))
        }

        function goToNextMonth() {
            monthView.changeDate = true
            monthView.finishChangeIfNeeded()
            monthView.resetViewPosition()
            monthView.incrementCurrentIndex()
        }

        function goToPreviousMonth() {
            monthView.changeDate = true
            monthView.finishChangeIfNeeded()
            monthView.resetViewPosition()
            monthView.decrementCurrentIndex()
        }

        Connections {
            target: root
            function onExpandedChanged() {
                if (root.expanded) {
                    calendarBackend.resetToToday()
                    root.currentDate = root.today
                    root.currentView = 0
                    monthView.resetViewPosition()
                }
            }
        }

        Connections {
            target: calendarBackend
            function onMonthChanged() {
                fullRep.updateAdjacentMonths()
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
                onPreviousMonth: fullRep.goToPreviousMonth()
                onNextMonth: fullRep.goToNextMonth()
            }

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true

                ListView {
                    id: monthView
                    anchors.fill: parent
                    visible: root.currentView === 0
                    clip: true

                    model: 3
                    snapMode: ListView.SnapToItem
                    highlightRangeMode: ListView.StrictlyEnforceRange
                    highlightMoveDuration: Kirigami.Units.longDuration
                    highlightMoveVelocity: -1
                    reuseItems: true
                    keyNavigationEnabled: false

                    property bool changeDate: false
                    property bool dragHandled: false

                    function finishChangeIfNeeded() {
                        if (verticalVelocity != 0.0) {
                            handleDateChange((verticalVelocity < 0.0) ? -1 : 1)
                        }
                    }

                    function resetViewPosition() {
                        currentIndex = 1
                        positionViewAtIndex(1, ListView.Beginning)
                    }

                    function handleDrag() {
                        if (dragHandled) {
                            resetViewPosition()
                            return true
                        }
                        if (draggingVertically) {
                            dragHandled = true
                        }
                        return false
                    }

                    function handleDateChange(direction) {
                        if (handleDrag()) {
                            return
                        }
                        if (changeDate) {
                            if (direction < 0) {
                                calendarBackend.previousMonth()
                            } else {
                                calendarBackend.nextMonth()
                            }
                        } else {
                            changeDate = true
                        }
                        resetViewPosition()
                    }

                    onAtYEndChanged: {
                        if (atYEnd) {
                            handleDateChange(1)
                        }
                    }

                    onAtYBeginningChanged: {
                        if (atYBeginning) {
                            handleDateChange(-1)
                        }
                    }

                    onDraggingVerticallyChanged: {
                        if (draggingVertically === false) {
                            dragHandled = false
                        }
                    }

                    Component.onCompleted: {
                        currentIndex = 1
                    }

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
                        highlightShape: root.config.dayHighlightShape
                        highlightColor: root.config.highlightColor

                        backend: index === 0 ? previousCalendar : (index === 2 ? nextCalendar : calendarBackend)
                        gridModel: index === 0 ? previousCalendar.daysModel : (index === 2 ? nextCalendar.daysModel : calendarBackend.daysModel)

                        onDateSelected: (d) => {
                            root.currentDate = d
                        }
                    }

                    WheelHandler {
                        acceptedDevices: PointerDevice.Mouse
                        orientation: Qt.Vertical
                        onWheel: (wheel) => {
                            while (rotation >= 15) {
                                rotation -= 15
                                fullRep.goToPreviousMonth()
                            }
                            while (rotation <= -15) {
                                rotation += 15
                                fullRep.goToNextMonth()
                            }
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
