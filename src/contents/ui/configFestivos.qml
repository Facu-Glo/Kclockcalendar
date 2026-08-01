import QtQuick
import QtQuick.Layouts
import org.kde.kcmutils as KCM
import org.kde.kirigami as Kirigami
import org.kde.kirigami.delegates as KD
import org.kde.kitemmodels as KItemModels
import org.kde.kholidays as KHolidays
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.private.holidayevents as Private

KCM.ScrollViewKCM {
    id: root

    property alias cfg_showHolidays: showHolidaysCheck.checked

    property var oldSelectedRegions
    property bool unsavedChanges

    function saveConfig() {
        configHelper.saveConfig();
        root.oldSelectedRegions = [...configHelper.selectedRegions]
        root.unsavedChanges = false
    }

    function checkUnsavedChanges() {
        root.unsavedChanges = !(configHelper.selectedRegions.every(entry => root.oldSelectedRegions.includes(entry)) && root.oldSelectedRegions.every(entry => configHelper.selectedRegions.includes(entry)))
    }

    Private.HolidayRegionsConfig {
        id: configHelper
        Component.onCompleted: root.oldSelectedRegions = [...configHelper.selectedRegions]
    }

    header: ColumnLayout {
        Layout.fillWidth: true
        spacing: Kirigami.Units.smallSpacing

        PlasmaComponents.CheckBox {
            id: showHolidaysCheck
            text: "Show holidays in the calendar"
        }

        Kirigami.SearchField {
            id: filter

            Layout.fillWidth: true
            KeyNavigation.down: holidaysView
        }
    }

    view: ListView {
        id: holidaysView

        activeFocusOnTab: true
        clip: true
        reuseItems: true

        model: KItemModels.KSortFilterProxyModel {
            sourceModel: KHolidays.HolidayRegionsModel {}
            filterCaseSensitivity: Qt.CaseInsensitive
            filterString: filter.text
            filterRoleName: "name"
        }

        delegate: KD.CheckSubtitleDelegate {
            id: delegate

            required property string region
            required property string name
            required property string description

            text: name
            subtitle: description

            checked: configHelper.selectedRegions.includes(region)
            width: ListView.view.width

            onClicked: {
                if (checked) {
                    configHelper.addRegion(region)
                } else {
                    configHelper.removeRegion(region)
                }
                root.checkUnsavedChanges()
            }
        }
    }
}
