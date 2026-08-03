import QtQuick
import org.kde.plasma.configuration

ConfigModel {
    ConfigCategory {
        name: i18nc("@title", "General")
        icon: "configure"
        source: "configGeneral.qml"
    }
    ConfigCategory {
        name: i18nc("@title", "Appearance")
        icon: "preferences-desktop-font"
        source: "configAppearance.qml"
    }
    ConfigCategory {
        name: i18nc("@title", "Calendar")
        icon: "view-calendar-month"
        source: "configCalendar.qml"
    }
}
