import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore

ColumnLayout {
    id: root
    signal monthTitleClicked()
    signal previousMonth()
    signal nextMonth()
    property date now: new Date()
    property date day: new Date()
    property string monthTitle: ""
    required property QtObject config

    readonly property bool isTopPanel: Plasmoid.location === PlasmaCore.Types.TopEdge

    spacing: 14

    ColumnLayout {
        spacing: root.isTopPanel ? -14 : 4

        PlasmaComponents.Label {
            font.pixelSize: root.config.bigClockFontSize
            font.weight: root.config.resolvedPopupFont.weight
            font.family: root.config.resolvedPopupFont.family
            font.italic: root.config.resolvedPopupFont.italic
            color: root.config.textColor
            text: Qt.locale().toString(root.now, root.config.popupTimeFormat)
            topPadding: 0
            bottomPadding: 0
        }

        PlasmaComponents.Label {
            font.pixelSize: 13
            opacity: 0.85
            font.family: root.config.resolvedFont.family
            font.italic: root.config.resolvedFont.italic
            color: root.config.textColor
            text: Qt.locale().toString(root.day, "dddd d MMMM yyyy")
            topPadding: 0
        }
    }

    Rectangle {
        Layout.fillWidth: true
        height: 1
        color: Kirigami.Theme.textColor
        opacity: 0.12
    }

    Item {
        Layout.fillWidth: true
        implicitHeight: monthTitleBtn.implicitHeight
        Layout.topMargin: 4
        Layout.bottomMargin: 4

        PlasmaComponents.AbstractButton {
            id: monthTitleBtn
            anchors.centerIn: parent
            implicitWidth: monthLabel.implicitWidth + 12
            implicitHeight: monthLabel.implicitHeight + 8
            hoverEnabled: true
            background: null

            onClicked: root.monthTitleClicked()

            Rectangle {
                anchors.fill: parent
                radius: 4
                color: {
                    if (monthTitleBtn.pressed) return Qt.alpha(root.config.highlightColor, 0.25)
                    if (monthTitleBtn.hovered) return Qt.alpha(root.config.highlightColor, 0.15)
                    return "transparent"
                }
                border.width: monthTitleBtn.hovered ? 1 : 0
                border.color: Qt.alpha(root.config.highlightColor, 0.4)
            }

            contentItem: PlasmaComponents.Label {
                id: monthLabel
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 14
                font.weight: Font.Medium
                font.family: root.config.resolvedFont.family
                font.italic: root.config.resolvedFont.italic
                color: root.config.textColor
                text: root.monthTitle
            }
        }

        RowLayout {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            spacing: 4

            PlasmaComponents.ToolButton {
                icon.name: "go-up-symbolic"
                display: PlasmaComponents.AbstractButton.IconOnly
                onClicked: root.previousMonth()
            }

            PlasmaComponents.ToolButton {
                icon.name: "go-down-symbolic"
                display: PlasmaComponents.AbstractButton.IconOnly
                onClicked: root.nextMonth()
            }
        }
    }
}
