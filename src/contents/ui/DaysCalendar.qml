import QtQuick
import org.kde.kirigami as Kirigami
import org.kde.plasma.workspace.calendar as PlasmaCalendar

Item {
    id: daysCalendar

    signal dateSelected(date date)

    property int rows
    property int columns
    property PlasmaCalendar.Calendar backend
    required property int dateMatchingPrecision
    property date todayDate: new Date()
    property date selectedDate: new Date()
    property color highlightColor: Kirigami.Theme.highlightColor
    property QtObject dateUtils: DateUtils {}

    readonly property int cellWidth: Math.floor(width / columns)
    readonly property int cellHeight: Math.floor(height / (rows + 1))

    Grid {
        id: calendarGrid
        anchors.fill: parent

        columns: daysCalendar.columns
        rows: daysCalendar.rows + 1

        Repeater {
            id: dayOfWeekHeaderRepeater
            model: daysCalendar.columns

            Kirigami.Heading {
                required property int index

                width: daysCalendar.cellWidth
                height: daysCalendar.cellHeight
                text: Qt.locale().dayName(((daysCalendar.backend ? daysCalendar.backend.firstDayOfWeek - 1 : 0) + index) % 7 + 1, Locale.ShortFormat)
                textFormat: Text.PlainText
                level: 3
                type: Kirigami.Heading.Type.Primary
                opacity: 0.85
                font.weight: Font.DemiBold
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }

        Repeater {
            id: gridRepeater
            model: daysCalendar.backend ? daysCalendar.backend.daysModel : null

            DayDelegate {
                width: daysCalendar.cellWidth
                height: daysCalendar.cellHeight
                daysModel: daysCalendar.backend ? daysCalendar.backend.daysModel : null
                dateMatchingPrecision: daysCalendar.dateMatchingPrecision
                todayDate: daysCalendar.todayDate
                selectedDate: daysCalendar.selectedDate
                highlightColor: daysCalendar.highlightColor
                dateUtils: daysCalendar.dateUtils

                onClicked: {
                    daysCalendar.dateSelected(this.thisDate)
                }
            }
        }
    }
}
