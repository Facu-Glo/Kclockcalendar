import QtQuick
import org.kde.kirigami as Kirigami
import org.kde.plasma.workspace.calendar as PlasmaCalendar

Item {
    id: daysCalendar

    signal activated(int index, var date, var item)

    property int rows
    property int columns
    property PlasmaCalendar.Calendar backend
    required property int dateMatchingPrecision
    property date todayDate: new Date()
    property date selectedDate: new Date()
    property int highlightShape: 0
    property color highlightColor: Kirigami.Theme.highlightColor

    property alias dayOfWeekHeaderModel: dayOfWeekHeaderRepeater.model
    property alias gridModel: gridRepeater.model

    readonly property int cellWidth: Math.floor(width / columns)
    readonly property int cellHeight: Math.floor(height / (rows + 1))

    Grid {
        id: calendarGrid
        anchors.fill: parent

        columns: daysCalendar.columns
        rows: daysCalendar.rows + 1

        // Encabezados de días de la semana
        Repeater {
            id: dayOfWeekHeaderRepeater

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

        // Días
        Repeater {
            id: gridRepeater

            DayDelegate {
                width: daysCalendar.cellWidth
                height: daysCalendar.cellHeight
                dateMatchingPrecision: daysCalendar.dateMatchingPrecision
                todayDate: daysCalendar.todayDate
                selectedDate: daysCalendar.selectedDate
                highlightShape: daysCalendar.highlightShape
                highlightColor: daysCalendar.highlightColor

                onClicked: {
                    daysCalendar.activated(index, model, this)
                }
            }
        }
    }
}
