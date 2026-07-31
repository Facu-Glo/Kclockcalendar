import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.extras as PlasmaExtras
import org.kde.kirigami as Kirigami
import org.kde.plasma.workspace.calendar as PlasmaCalendar

PlasmoidItem {
    id: root

    preferredRepresentation: compactRepresentation

    property date now: new Date()
    property date currentDate: now
    property date today: now

    property string resolvedTimeFormat: {
        var fmt = Plasmoid.configuration.use24hFormat ? "HH" : "hh"
        fmt += ":mm"
        if (Plasmoid.configuration.showSeconds) fmt += ":ss"
        if (!Plasmoid.configuration.use24hFormat) fmt += " AP"
        return fmt
    }

    property string panelTextColor: Plasmoid.configuration.textColor || Kirigami.Theme.textColor

    property string popupTimeFormat: {
        var fmt = "hh:mm"
        if (Plasmoid.configuration.showPopupSeconds) fmt += ":ss"
        return fmt
    }

    property font resolvedFont: {
        var f = Plasmoid.configuration.font
        return f.family ? f : Kirigami.Theme.defaultFont
    }

    property font resolvedPopupFont: {
        var f = Plasmoid.configuration.popupFont
        return f.family ? f : Kirigami.Theme.defaultFont
    }

    property int currentView: 0 // 0 = days, 1 = months

    property int panelHAlignment: {
        switch (Plasmoid.configuration.textAlignment) {
            case 0: return Text.AlignLeft
            case 2: return Text.AlignRight
            default: return Text.AlignHCenter
        }
    }

    Timer {
        interval: 500
        running: true
        repeat: true
        onTriggered: root.now = new Date()
    }

    compactRepresentation: MouseArea {
        id: compactArea
        Layout.preferredWidth: layoutLoader.implicitWidth + 8
        Layout.minimumWidth: 40
        cursorShape: Qt.PointingHandCursor
        onClicked: root.expanded = !root.expanded

        Loader {
            id: layoutLoader
            anchors.centerIn: parent
            sourceComponent: Plasmoid.configuration.layoutPosition === 2 ? rowLayoutComponent : columnLayoutComponent
        }

        Component {
            id: columnLayoutComponent
            ColumnLayout {
                spacing: 0

                PlasmaComponents.Label {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.fillWidth: true
                    font.pixelSize: Plasmoid.configuration.timeFontSize
                    font.weight: root.resolvedFont.weight
                    font.family: root.resolvedFont.family
                    font.italic: root.resolvedFont.italic
                    color: root.panelTextColor
                    horizontalAlignment: root.panelHAlignment
                    visible: Plasmoid.configuration.layoutPosition === 0 || !Plasmoid.configuration.showDate
                    text: Qt.locale().toString(root.now, root.resolvedTimeFormat)
                }

                PlasmaComponents.Label {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.fillWidth: true
                    font.pixelSize: Plasmoid.configuration.dateFontSize
                    font.weight: root.resolvedFont.weight
                    font.family: root.resolvedFont.family
                    font.italic: root.resolvedFont.italic
                    opacity: 0.85
                    color: root.panelTextColor
                    horizontalAlignment: root.panelHAlignment
                    visible: Plasmoid.configuration.layoutPosition === 1 && Plasmoid.configuration.showDate
                    text: Qt.locale().toString(root.now, Plasmoid.configuration.dateFormat || "dd.MM.yy")
                }

                PlasmaComponents.Label {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.fillWidth: true
                    font.pixelSize: Plasmoid.configuration.timeFontSize
                    font.weight: root.resolvedFont.weight
                    font.family: root.resolvedFont.family
                    font.italic: root.resolvedFont.italic
                    color: root.panelTextColor
                    horizontalAlignment: root.panelHAlignment
                    visible: Plasmoid.configuration.layoutPosition === 1 && Plasmoid.configuration.showDate
                    text: Qt.locale().toString(root.now, root.resolvedTimeFormat)
                }

                PlasmaComponents.Label {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.fillWidth: true
                    font.pixelSize: Plasmoid.configuration.dateFontSize
                    font.weight: root.resolvedFont.weight
                    font.family: root.resolvedFont.family
                    font.italic: root.resolvedFont.italic
                    opacity: 0.85
                    color: root.panelTextColor
                    horizontalAlignment: root.panelHAlignment
                    visible: Plasmoid.configuration.layoutPosition === 0 && Plasmoid.configuration.showDate
                    text: Qt.locale().toString(root.now, Plasmoid.configuration.dateFormat || "dd.MM.yy")
                }
            }
        }

        Component {
            id: rowLayoutComponent
            RowLayout {
                spacing: 4

                PlasmaComponents.Label {
                    Layout.alignment: Qt.AlignHCenter
                    font.pixelSize: Plasmoid.configuration.timeFontSize
                    font.weight: root.resolvedFont.weight
                    font.family: root.resolvedFont.family
                    font.italic: root.resolvedFont.italic
                    color: root.panelTextColor
                    horizontalAlignment: root.panelHAlignment
                    text: Qt.locale().toString(root.now, root.resolvedTimeFormat)
                }

                PlasmaComponents.Label {
                    Layout.alignment: Qt.AlignHCenter
                    visible: Plasmoid.configuration.showDate
                    font.pixelSize: Plasmoid.configuration.dateFontSize
                    font.weight: root.resolvedFont.weight
                    font.family: root.resolvedFont.family
                    font.italic: root.resolvedFont.italic
                    opacity: 0.85
                    color: root.panelTextColor
                    horizontalAlignment: root.panelHAlignment
                    text: Qt.locale().toString(root.now, Plasmoid.configuration.dateFormat || "dd.MM.yy")
                }
            }
        }
    }

    fullRepresentation: PlasmaExtras.Representation {
        Layout.preferredWidth: 340
        Layout.preferredHeight: 460

        PlasmaCalendar.Calendar {
            id: calendarBackend
            days: 7
            weeks: 6
            firstDayOfWeek: Plasmoid.configuration.firstDayOfWeek || Qt.locale().firstDayOfWeek
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

            ColumnLayout {
                spacing: 4

                PlasmaComponents.Label {
                    font.pixelSize: Plasmoid.configuration.bigClockFontSize
                    font.weight: root.resolvedPopupFont.weight
                    font.family: root.resolvedPopupFont.family
                    font.italic: root.resolvedPopupFont.italic
                    color: Plasmoid.configuration.textColor || Kirigami.Theme.textColor
                    text: Qt.locale().toString(root.now, root.popupTimeFormat)
                }

                PlasmaComponents.Label {
                    font.pixelSize: 13
                    opacity: 0.85
                    font.family: root.resolvedFont.family
                    font.italic: root.resolvedFont.italic
                    color: Plasmoid.configuration.textColor || Kirigami.Theme.textColor
                    text: Qt.locale().toString(root.now, "dddd d MMMM yyyy")
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: Kirigami.Theme.textColor
                opacity: 0.12
            }

            Item {
                Layout.fillWidth: true
                implicitHeight: monthTitleBtn.implicitHeight
                Layout.topMargin: 4
                Layout.bottomMargin: 4

                PlasmaComponents.AbstractButton {
                    id: monthTitleBtn
                    anchors.centerIn: parent
                    implicitWidth: monthLabel.implicitWidth + 12
                    implicitHeight: monthLabel.implicitHeight + 8
                    hoverEnabled: true
                    background: null

                    onClicked: root.currentView = root.currentView === 0 ? 1 : 0

                    Rectangle {
                        anchors.fill: parent
                        radius: 4
                        color: {
                            if (monthTitleBtn.pressed) return Qt.alpha(Plasmoid.configuration.highlightColor || Kirigami.Theme.highlightColor, 0.25)
                            if (monthTitleBtn.hovered) return Qt.alpha(Plasmoid.configuration.highlightColor || Kirigami.Theme.highlightColor, 0.15)
                            return "transparent"
                        }
                        border.width: monthTitleBtn.hovered ? 1 : 0
                        border.color: Qt.alpha(Plasmoid.configuration.highlightColor || Kirigami.Theme.highlightColor, 0.4)
                    }

                    contentItem: PlasmaComponents.Label {
                        id: monthLabel
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: 14
                        font.weight: Font.Medium
                        font.family: root.resolvedFont.family
                        font.italic: root.resolvedFont.italic
                        color: Plasmoid.configuration.textColor || Kirigami.Theme.textColor
                        text: calendarBackend.monthName + " " + calendarBackend.year
                    }
                }

                RowLayout {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 4

                    PlasmaComponents.ToolButton {
                        icon.name: "go-up-symbolic"
                        display: PlasmaComponents.AbstractButton.IconOnly
                        onClicked: calendarBackend.previousMonth()
                    }

                    PlasmaComponents.ToolButton {
                        icon.name: "go-down-symbolic"
                        display: PlasmaComponents.AbstractButton.IconOnly
                        onClicked: calendarBackend.nextMonth()
                    }
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                DaysCalendar {
                    id: customCalendar
                    anchors.fill: parent
                    visible: root.currentView === 0

                    columns: calendarBackend.days
                    rows: calendarBackend.weeks
                    dateMatchingPrecision: PlasmaCalendar.Calendar.MatchYearMonthAndDay
                    borderWidth: 0
                    dayOfWeekHeaderModel: calendarBackend.days
                    todayDate: root.today
                    selectedDate: root.currentDate
                    highlightShape: Plasmoid.configuration.dayHighlightShape
                    highlightColor: Plasmoid.configuration.highlightColor || Kirigami.Theme.highlightColor

                    backend: calendarBackend
                    gridModel: calendarBackend.daysModel

                    onActivated: (index, dateModel, item) => {
                        root.currentDate = new Date(dateModel.yearNumber, dateModel.monthNumber - 1, dateModel.dayNumber)
                    }
                }

                MonthsCalendar {
                    anchors.fill: parent
                    visible: root.currentView === 1
                    backend: calendarBackend
                    highlightColor: Plasmoid.configuration.highlightColor || Kirigami.Theme.highlightColor
                    onMonthSelected: (month) => {
                        calendarBackend.goToMonth(month)
                        root.currentView = 0
                    }
                }
            }
        }
    }
}
