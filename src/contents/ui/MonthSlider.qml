import QtQuick
import org.kde.kirigami as Kirigami
import org.kde.plasma.workspace.calendar as PlasmaCalendar

ListView {
    id: monthSlider

    required property PlasmaCalendar.Calendar backend
    required property PlasmaCalendar.EventPluginsManager eventPluginsManager

    readonly property alias previousCalendar: previousBackend
    readonly property alias nextCalendar: nextBackend

    model: 3
    snapMode: ListView.SnapToItem
    highlightRangeMode: ListView.StrictlyEnforceRange
    highlightMoveDuration: Kirigami.Units.longDuration
    highlightMoveVelocity: -1
    reuseItems: true
    keyNavigationEnabled: false
    clip: true

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
                backend.previousMonth()
            } else {
                backend.nextMonth()
            }
        } else {
            changeDate = true
        }
        resetViewPosition()
    }

    function goToNextMonth() {
        changeDate = true
        finishChangeIfNeeded()
        resetViewPosition()
        incrementCurrentIndex()
    }

    function goToPreviousMonth() {
        changeDate = true
        finishChangeIfNeeded()
        resetViewPosition()
        decrementCurrentIndex()
    }

    function modulo(a, n) {
        return ((((a - 1) % n) + n) % n) + 1
    }

    function adjacentMonthNumber(offset) {
        return modulo(backend.month + offset, 12)
    }

    function adjacentYear(offset) {
        const month = adjacentMonthNumber(offset)
        if (offset < 0 && month === 12) return backend.year - 1
        if (offset > 0 && month === 1) return backend.year + 1
        return backend.year
    }

    function updateAdjacentMonths() {
        previousBackend.goToYearAndMonth(adjacentYear(-1), adjacentMonthNumber(-1))
        nextBackend.goToYearAndMonth(adjacentYear(1), adjacentMonthNumber(1))
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

    PlasmaCalendar.Calendar {
        id: previousBackend
        days: monthSlider.backend.days
        weeks: monthSlider.backend.weeks
        firstDayOfWeek: monthSlider.backend.firstDayOfWeek
        today: monthSlider.backend.today
        Component.onCompleted: {
            goToYearAndMonth(monthSlider.adjacentYear(-1), monthSlider.adjacentMonthNumber(-1))
            daysModel.setPluginsManager(monthSlider.eventPluginsManager)
        }
    }

    PlasmaCalendar.Calendar {
        id: nextBackend
        days: monthSlider.backend.days
        weeks: monthSlider.backend.weeks
        firstDayOfWeek: monthSlider.backend.firstDayOfWeek
        today: monthSlider.backend.today
        Component.onCompleted: {
            goToYearAndMonth(monthSlider.adjacentYear(1), monthSlider.adjacentMonthNumber(1))
            daysModel.setPluginsManager(monthSlider.eventPluginsManager)
        }
    }

    Connections {
        target: monthSlider.backend
        function onMonthChanged() {
            monthSlider.updateAdjacentMonths()
        }
    }

    WheelHandler {
        acceptedDevices: PointerDevice.Mouse
        orientation: Qt.Vertical
        onWheel: (wheel) => {
            while (rotation >= 15) {
                rotation -= 15
                monthSlider.goToPreviousMonth()
            }
            while (rotation <= -15) {
                rotation += 15
                monthSlider.goToNextMonth()
            }
        }
    }
}
