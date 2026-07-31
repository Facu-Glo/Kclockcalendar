import QtQuick
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM
import org.kde.plasma.components as PlasmaComponents

KCM.SimpleKCM {
    id: configPage

    property alias cfg_timeFormat: timeFormatInput.text
    property alias cfg_dateFormat: dateFormatInput.text
    property alias cfg_showDate: showDateCheck.checked
    property alias cfg_layoutPosition: layoutBox.currentIndex
    property alias cfg_showSeconds: showSecondsCheck.checked
    property alias cfg_showPopupSeconds: popupSecondsCheck.checked
    property alias cfg_use24hFormat: use24hCheck.checked
    property alias cfg_firstDayOfWeek: firstDayBox.currentIndex
    property alias cfg_dateFirst: dateFirstCheck.checked

    Kirigami.FormLayout {
        id: formLayout
        anchors.left: parent.left
        anchors.right: parent.right

        PlasmaComponents.TextField {
            id: timeFormatInput
            Kirigami.FormData.label: "Time format:"
            placeholderText: "hh:mm:ss"
        }

        PlasmaComponents.TextField {
            id: dateFormatInput
            enabled: showDateCheck.checked
            Kirigami.FormData.label: "Date format:"
            placeholderText: "dd.MM.yy"
        }

        PlasmaComponents.CheckBox {
            id: showDateCheck
            Kirigami.FormData.label: "Show date in panel:"
        }

        QQC2.ComboBox {
            id: layoutBox
            enabled: showDateCheck.checked
            Kirigami.FormData.label: "Position in panel:"
            model: ["Time above, Date below", "Date above, Time below", "Time and date together"]
        }

        PlasmaComponents.CheckBox {
            id: dateFirstCheck
            enabled: layoutBox.currentIndex === 2
            Kirigami.FormData.label: "Date first (horizontal):"
        }

        PlasmaComponents.CheckBox {
            id: showSecondsCheck
            Kirigami.FormData.label: "Show seconds:"
        }

        PlasmaComponents.CheckBox {
            id: popupSecondsCheck
            Kirigami.FormData.label: "Show seconds (popup):"
        }

        PlasmaComponents.CheckBox {
            id: use24hCheck
            Kirigami.FormData.label: "24-hour format:"
        }

        QQC2.ComboBox {
            id: firstDayBox
            Kirigami.FormData.label: "First day of week:"
            model: ["Default", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        }
    }
}
