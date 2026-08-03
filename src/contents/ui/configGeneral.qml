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
    property alias cfg_firstDayOfWeek: firstDayBox.currentIndex

    Kirigami.FormLayout {
        id: formLayout
        anchors.left: parent.left
        anchors.right: parent.right

        PlasmaComponents.TextField {
            id: timeFormatInput
            Kirigami.FormData.label: "Time format (panel):"
            placeholderText: "HH:mm:ss"
        }

        PlasmaComponents.TextField {
            id: dateFormatInput
            Kirigami.FormData.label: "Date format (panel):"
            placeholderText: "dd/MM/yy"
        }

        PlasmaComponents.TextField {
            id: popupTimeFormatInput
            Kirigami.FormData.label: "Time format (popup):"
            placeholderText: "HH:mm:ss"
        }

        PlasmaComponents.TextField {
            id: popupDateFormatInput
            Kirigami.FormData.label: "Date format (popup):"
            placeholderText: "dddd d MMMM yyyy"
        }

        PlasmaComponents.Label {
            text: "<a href='https://doc.qt.io/qt-6/qml-qtqml-qt.html#formatDateTime-method'>Date and time format documentation</a>"
            onLinkActivated: (link) => Qt.openUrlExternally(link)

            HoverHandler {
                cursorShape: Qt.PointingHandCursor
            }
        }

        QQC2.ComboBox {
            id: firstDayBox
            Kirigami.FormData.label: "First day of week:"
            model: ["Default", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        }
    }
}
