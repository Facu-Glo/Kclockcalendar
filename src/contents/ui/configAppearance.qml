import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Dialogs as QtDialogs
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.plasmoid
import org.kde.kquickcontrols as KQuickControls

KCM.SimpleKCM {
    id: configPage

    property font cfg_font
    property alias cfg_showDate: showDateCheck.checked
    property alias cfg_layoutPosition: layoutBox.currentValue
    property alias cfg_dateAbove: dateAboveCheck.checked
    property alias cfg_dateMonthBelow: dateMonthBelowCheck.checked
    property alias cfg_dateFirst: dateFirstCheck.checked
    property alias cfg_dateTimeSpacing: dateTimeSpacingInput.value
    property alias cfg_timeFontSize: timeFontSizeInput.value
    property alias cfg_dateFontSize: dateFontSizeInput.value
    property alias cfg_ampmFontSize: ampmFontSizeInput.value
    property alias cfg_bigClockFontSize: bigClockFontSizeInput.value
    property alias cfg_textColor: colorInput.text
    property alias cfg_textAlignment: alignmentBox.currentValue
    property string cfg_highlightColor

    Kirigami.FormLayout {
        id: formLayout
        anchors.left: parent.left
        anchors.right: parent.right

        PlasmaComponents.CheckBox {
            id: showDateCheck
            Kirigami.FormData.label: i18n("Show date in panel:")
        }

        QQC2.ComboBox {
            id: layoutBox
            Kirigami.FormData.label: i18n("Position in panel:")
            textRole: "text"
            valueRole: "value"
            model: [
                { value: "vertical", text: i18n("Vertical") },
                { value: "horizontal", text: i18n("Horizontal") },
                { value: "stacked", text: i18n("Stacked") }
            ]
        }

        PlasmaComponents.CheckBox {
            id: dateAboveCheck
            visible: layoutBox.currentValue === "vertical" || layoutBox.currentValue === "stacked"
            enabled: showDateCheck.checked
            Kirigami.FormData.label: i18n("Date above:")
        }

        PlasmaComponents.CheckBox {
            id: dateMonthBelowCheck
            visible: layoutBox.currentValue === "stacked"
            enabled: showDateCheck.checked
            Kirigami.FormData.label: i18n("Month below date (stacked):")
        }

        PlasmaComponents.CheckBox {
            id: dateFirstCheck
            visible: layoutBox.currentValue === "horizontal"
            enabled: showDateCheck.checked
            Kirigami.FormData.label: i18n("Date first:")
        }

        QQC2.SpinBox {
            id: dateTimeSpacingInput
            from: 0
            to: 24
            enabled: showDateCheck.checked
            Kirigami.FormData.label: i18n("Space between time and date:")
        }

        QtDialogs.FontDialog {
            id: fontDialog
            onAccepted: cfg_font = fontDialog.selectedFont
        }

        Row {
            Kirigami.FormData.label: i18n("Font:")
            spacing: Kirigami.Units.smallSpacing

            PlasmaComponents.Label {
                anchors.verticalCenter: parent.verticalCenter
                text: cfg_font.family || i18n("(default)")
            }

            QQC2.Button {
                text: i18n("Choose...")
                onClicked: {
                    if (cfg_font && cfg_font.family) fontDialog.selectedFont = cfg_font
                    fontDialog.open()
                }
            }
        }

        QQC2.SpinBox {
            id: timeFontSizeInput
            from: 8
            to: 72
            Kirigami.FormData.label: i18n("Time size (panel):")
        }

        QQC2.SpinBox {
            id: dateFontSizeInput
            from: 8
            to: 72
            Kirigami.FormData.label: i18n("Date size (panel):")
        }

        QQC2.SpinBox {
            id: ampmFontSizeInput
            from: 8
            to: 72
            visible: layoutBox.currentValue === "stacked"
            enabled: {
                var f = Plasmoid.configuration.timeFormat || ""
                return layoutBox.currentValue === "stacked" && (f.includes("ap") || f.includes("AP"))
            }
            Kirigami.FormData.label: i18n("AM/PM size (panel):")
        }

        QQC2.SpinBox {
            id: bigClockFontSizeInput
            from: 20
            to: 120
            Kirigami.FormData.label: i18n("Clock size (popup):")
        }

        PlasmaComponents.TextField {
            id: colorInput
            Kirigami.FormData.label: i18n("Text color:")
            placeholderText: i18n("empty = default (e.g. #ffffff)")
        }

        QQC2.ComboBox {
            id: alignmentBox
            Kirigami.FormData.label: i18n("Alignment in panel:")
            textRole: "text"
            valueRole: "value"
            model: [
                { value: "left", text: i18n("Left") },
                { value: "center", text: i18n("Center") },
                { value: "right", text: i18n("Right") }
            ]
        }

        Row {
            Kirigami.FormData.label: i18n("Highlight color:")

            KQuickControls.ColorButton {
                id: highlightColorBtn
                onAccepted: cfg_highlightColor = highlightColorBtn.color
            }

            QQC2.Button {
                text: i18n("Default")
                onClicked: {
                    cfg_highlightColor = ""
                    highlightColorBtn.color = Kirigami.Theme.highlightColor
                }
            }
        }

        Component.onCompleted: {
            if (cfg_highlightColor) {
                highlightColorBtn.color = cfg_highlightColor
            } else {
                highlightColorBtn.color = Kirigami.Theme.highlightColor
            }
        }
    }
}
