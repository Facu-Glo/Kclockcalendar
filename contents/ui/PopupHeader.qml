import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents

ColumnLayout {
    id: root

    signal monthTitleClicked()
    signal previousMonth()
    signal nextMonth()

    property date now: new Date()
    property date day: new Date()
    property string monthTitle: ""
    required property QtObject config

    spacing: 14

    ColumnLayout {
        Layout.alignment: Qt.AlignTop
        spacing: 0

        PlasmaComponents.Label {
            Layout.alignment: Qt.AlignTop
            Layout.topMargin: 16 
            font.family: "sans"
            font.pixelSize: root.config.bigClockFontSize
            font.weight: 100
            
            color: root.config.textColor
            text: Qt.locale().toString(root.now, root.config.popupTimeFormat)
        }

        PlasmaComponents.Label {
            Layout.alignment: Qt.AlignTop
            Layout.bottomMargin: 12

            font.family: "sans"
            font.pixelSize: 16
            font.weight: 300
            color: root.config.textColor
            text: Qt.locale().toString(root.day, "dddd d MMMM yyyy")
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
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
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
                font.family: "sans"
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
