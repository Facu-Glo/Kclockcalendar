import QtQuick
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.workspace.calendar as PlasmaCalendar

PlasmaComponents.AbstractButton {
    id: dayStyle

    required property var model
    required property bool isCurrent
    required property int yearNumber
    required property int dateMatchingPrecision

    property var daysModel: null
    property date todayDate: new Date()
    property date selectedDate: new Date()
    property color highlightColor: Kirigami.Theme.highlightColor
    property QtObject dateUtils: DateUtils {}

    opacity: dayStyle.isCurrent ? 1.0 : 0.35

    readonly property date thisDate: {
        const monthNumber = (dateMatchingPrecision >= PlasmaCalendar.Calendar.MatchYearAndMonth) ? model.monthNumber - 1 : 0;
        const dayNumber = (dateMatchingPrecision >= PlasmaCalendar.Calendar.MatchYearMonthAndDay) ? model.dayNumber : 1;
        return new Date(yearNumber, monthNumber, dayNumber);
    }

    readonly property bool isToday: dayStyle.dateUtils.isSameDay(dayStyle.todayDate, dayStyle.thisDate)
    readonly property bool isSelected: dayStyle.dateUtils.isSameDay(dayStyle.selectedDate, dayStyle.thisDate)

    readonly property bool isHoliday: dayStyle.model.containsEventItems === true

    readonly property var holidayTitles: {
        if (!dayStyle.daysModel || !dayStyle.isHoliday) return []
        const events = dayStyle.daysModel.eventsForDate(dayStyle.thisDate)
        const titles = []
        for (let i = 0; i < events.length; ++i) {
            if (events[i].isAllDay) titles.push(events[i].title)
        }
        return titles
    }

    hoverEnabled: isCurrent
    enabled: isCurrent

    Rectangle {
        anchors.fill: parent
        radius: 4

        color: {
            if (dayStyle.isToday) return Qt.alpha(dayStyle.highlightColor, 0.25);
            if (dayStyle.isSelected) return Qt.alpha(dayStyle.highlightColor, 0.25);
            if (dayStyle.hovered) return Qt.alpha(dayStyle.highlightColor, 0.15);
            return "transparent";
        }

        border.width: (dayStyle.isToday || dayStyle.isSelected || dayStyle.hovered) ? 1 : 0
        border.color: dayStyle.hovered ? Qt.alpha(dayStyle.highlightColor, 0.4) : dayStyle.highlightColor
    }

    contentItem: Item {
        PlasmaComponents.Label {
            anchors.fill: parent
            text: dayStyle.model.dayNumber !== undefined ? dayStyle.model.dayNumber : ""
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: 13
            font.weight: dayStyle.isToday ? Font.Bold : Font.Normal

            color: Kirigami.Theme.textColor
        }

        PlasmaComponents.Label {
            visible: text.length > 0
            text: dayStyle.model.subDayLabel || ""
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }
            font.pixelSize: Kirigami.Theme.smallFont.pixelSize
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            maximumLineCount: 1
            elide: Text.ElideRight
            color: Kirigami.Theme.textColor
        }
    }

    Rectangle {
        visible: dayStyle.model.eventCount !== undefined && dayStyle.model.eventCount > 0
        width: 4
        height: 4
        radius: 2
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 4
        color: dayStyle.highlightColor
    }

    PlasmaComponents.ToolTip {
        visible: dayStyle.hovered && dayStyle.holidayTitles.length > 0
        delay: 500
        text: dayStyle.holidayTitles.join("\n")
    }
}
