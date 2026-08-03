import QtQuick
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM
import org.kde.plasma.components as PlasmaComponents

KCM.SimpleKCM {
    id: configPage

    property alias cfg_timeFormat: timeFormatInput.text
    property alias cfg_popupTimeFormat: popupTimeFormatInput.text
    property alias cfg_popupDateFormat: popupDateFormatInput.text
    property alias cfg_dateFormat: dateFormatInput.text
    property alias cfg_firstDayOfWeek: firstDayBox.currentValue

    Kirigami.FormLayout {
        id: formLayout
        anchors.left: parent.left
        anchors.right: parent.right

        PlasmaComponents.TextField {
            id: timeFormatInput
            Kirigami.FormData.label: i18n("Time format (panel):")
            placeholderText: "HH:mm:ss"
        }

        PlasmaComponents.TextField {
            id: dateFormatInput
            Kirigami.FormData.label: i18n("Date format (panel):")
            placeholderText: "dd/MM/yy"
        }

        PlasmaComponents.TextField {
            id: popupTimeFormatInput
            Kirigami.FormData.label: i18n("Time format (popup):")
            placeholderText: "HH:mm:ss"
        }

        PlasmaComponents.TextField {
            id: popupDateFormatInput
            Kirigami.FormData.label: i18n("Date format (popup):")
            placeholderText: "dddd d MMMM yyyy"
        }

        PlasmaComponents.Label {
            text: i18n("<a href='https://doc.qt.io/qt-6/qml-qtqml-qt.html#formatDateTime-method'>Date and time format documentation</a>")
            onLinkActivated: (link) => Qt.openUrlExternally(link)

            HoverHandler {
                cursorShape: Qt.PointingHandCursor
            }
        }

        QQC2.ComboBox {
            id: firstDayBox
            Kirigami.FormData.label: i18n("First day of week:")
            textRole: "text"
            valueRole: "value"
            model: [
                { value: 0, text: i18n("Default") },
                { value: Qt.Monday, text: i18n("Monday") },
                { value: Qt.Tuesday, text: i18n("Tuesday") },
                { value: Qt.Wednesday, text: i18n("Wednesday") },
                { value: Qt.Thursday, text: i18n("Thursday") },
                { value: Qt.Friday, text: i18n("Friday") },
                { value: Qt.Saturday, text: i18n("Saturday") },
                { value: Qt.Sunday, text: i18n("Sunday") }
            ]
        }
    }
}
