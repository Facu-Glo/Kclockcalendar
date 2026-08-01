import QtQuick
import org.kde.kirigami as Kirigami
import org.kde.plasma.plasmoid

QtObject {
    id: root

    readonly property string timeFormat: {
        var fmt = Plasmoid.configuration.use24hFormat ? "HH" : "hh"
        fmt += ":mm"
        if (Plasmoid.configuration.showSeconds) fmt += ":ss"
        if (!Plasmoid.configuration.use24hFormat) fmt += " a"
        return fmt
    }

    readonly property string popupTimeFormat: {
        var fmt = Plasmoid.configuration.use24hFormat ? "HH" : "hh"
        fmt += ":mm"
        if (Plasmoid.configuration.showPopupSeconds) fmt += ":ss"
        if (!Plasmoid.configuration.use24hFormat) fmt += " a"
        return fmt
    }

    readonly property string dateFormat: Plasmoid.configuration.dateFormat || "dd.MM.yy"
    readonly property int layoutPosition: Plasmoid.configuration.layoutPosition
    readonly property bool dateAbove: Plasmoid.configuration.dateAbove
    readonly property bool dateFirst: Plasmoid.configuration.dateFirst
    readonly property bool showDate: Plasmoid.configuration.showDate
    readonly property bool showSeconds: Plasmoid.configuration.showSeconds
    readonly property bool showPopupSeconds: Plasmoid.configuration.showPopupSeconds
    readonly property int timeFontSize: Plasmoid.configuration.timeFontSize
    readonly property int dateFontSize: Plasmoid.configuration.dateFontSize
    readonly property int bigClockFontSize: Plasmoid.configuration.bigClockFontSize
    readonly property int dayHighlightShape: Plasmoid.configuration.dayHighlightShape
    readonly property int firstDayOfWeek: Plasmoid.configuration.firstDayOfWeek
    readonly property bool showHolidays: Plasmoid.configuration.showHolidays

    readonly property font resolvedFont: {
        var f = Plasmoid.configuration.font
        return f.family ? f : Kirigami.Theme.defaultFont
    }

    readonly property color textColor: Plasmoid.configuration.textColor || Kirigami.Theme.textColor
    readonly property color highlightColor: Plasmoid.configuration.highlightColor || Kirigami.Theme.highlightColor

    readonly property int panelHAlignment: {
        switch (Plasmoid.configuration.textAlignment) {
            case 0: return Text.AlignLeft
            case 2: return Text.AlignRight
            default: return Text.AlignHCenter
        }
    }
}
