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

    property date todayDate: new Date()
    property date selectedDate: new Date()
    property int highlightShape: 0
    property color highlightColor: Kirigami.Theme.highlightColor

    opacity: dayStyle.isCurrent ? 1.0 : 0.35

    readonly property date thisDate: {
        const monthNumber = (dateMatchingPrecision >= PlasmaCalendar.Calendar.MatchYearAndMonth) ? model.monthNumber - 1 : 0;
        const dayNumber = (dateMatchingPrecision >= PlasmaCalendar.Calendar.MatchYearMonthAndDay) ? model.dayNumber : 1;
        return new Date(yearNumber, monthNumber, dayNumber);
    }

    readonly property bool isToday: {
        return todayDate.getFullYear() === thisDate.getFullYear() &&
               todayDate.getMonth() === thisDate.getMonth() &&
               todayDate.getDate() === thisDate.getDate();
    }

    readonly property bool isSelected: {
        return selectedDate.getFullYear() === thisDate.getFullYear() &&
               selectedDate.getMonth() === thisDate.getMonth() &&
               selectedDate.getDate() === thisDate.getDate();
    }

    hoverEnabled: isCurrent
    enabled: isCurrent

    Rectangle {
        anchors.centerIn: parent
        width: dayStyle.highlightShape === 0 ? Math.min(parent.width, parent.height) - 6 : parent.width - 2
        height: dayStyle.highlightShape === 0 ? width : parent.height - 2
        radius: dayStyle.highlightShape === 0 ? width / 2 : 4

        color: {
            if (dayStyle.isToday) return Qt.alpha(dayStyle.highlightColor, 0.25);
            if (dayStyle.isSelected) return Qt.alpha(dayStyle.highlightColor, 0.25);
            if (dayStyle.hovered) return Qt.alpha(dayStyle.highlightColor, 0.15);
            return "transparent";
        }

        border.width: (dayStyle.isToday || dayStyle.isSelected || dayStyle.hovered) ? 1 : 0
        border.color: dayStyle.hovered ? Qt.alpha(dayStyle.highlightColor, 0.4) : dayStyle.highlightColor
    }

    contentItem: PlasmaComponents.Label {
        text: dayStyle.model.dayNumber !== undefined ? dayStyle.model.dayNumber : ""
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: 13
        font.weight: dayStyle.isToday ? Font.Bold : Font.Normal
        
        color: Kirigami.Theme.textColor
    }

    Rectangle {
        visible: dayStyle.model.eventCount !== undefined && dayStyle.model.eventCount > 0
        width: 4
        height: 4
        radius: 2
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 2
        color: dayStyle.highlightColor
    }
}
