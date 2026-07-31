import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Dialogs as QtDialogs
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM
import org.kde.plasma.components as PlasmaComponents
import org.kde.kquickcontrols as KQuickControls

KCM.SimpleKCM {
    id: configPage

    property font cfg_font
    property alias cfg_timeFontSize: timeFontSizeInput.value
    property alias cfg_dateFontSize: dateFontSizeInput.value
    property alias cfg_bigClockFontSize: bigClockFontSizeInput.value
    property alias cfg_textColor: colorInput.text
    property alias cfg_textAlignment: alignmentBox.currentIndex
    property alias cfg_dayHighlightShape: shapeBox.currentIndex
    property string cfg_highlightColor

    Kirigami.FormLayout {
        id: formLayout
        anchors.left: parent.left
        anchors.right: parent.right

        QtDialogs.FontDialog {
            id: fontDialog
            onAccepted: cfg_font = fontDialog.selectedFont
        }

        Row {
            Kirigami.FormData.label: "Font:"
            spacing: Kirigami.Units.smallSpacing

            PlasmaComponents.Label {
                anchors.verticalCenter: parent.verticalCenter
                text: cfg_font.family || "(default)"
            }

            QQC2.Button {
                text: "Choose..."
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
            Kirigami.FormData.label: "Time size (panel):"
        }

        QQC2.SpinBox {
            id: dateFontSizeInput
            from: 8
            to: 72
            Kirigami.FormData.label: "Date size (panel):"
        }

        QQC2.SpinBox {
            id: bigClockFontSizeInput
            from: 20
            to: 120
            Kirigami.FormData.label: "Clock size (popup):"
        }

        PlasmaComponents.TextField {
            id: colorInput
            Kirigami.FormData.label: "Text color:"
            placeholderText: "empty = default (e.g. #ffffff)"
        }

        QQC2.ComboBox {
            id: alignmentBox
            Kirigami.FormData.label: "Alignment in panel:"
            model: ["Left", "Center", "Right"]
        }

        QQC2.ComboBox {
            id: shapeBox
            Kirigami.FormData.label: "Highlight shape:"
            model: ["Circle", "Square"]
        }

        Row {
            Kirigami.FormData.label: "Highlight color:"

            KQuickControls.ColorButton {
                id: highlightColorBtn
                onAccepted: cfg_highlightColor = highlightColorBtn.color
            }

            QQC2.Button {
                text: "Default"
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
