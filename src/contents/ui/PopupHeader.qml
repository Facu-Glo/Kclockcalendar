import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents

ColumnLayout {
    id: root

    signal monthTitleClicked()
    signal previousMonth()
    signal nextMonth()
    signal todayClicked()

    property string clockText: ""
    property string dateText: ""
    property string monthTitle: ""
    property int clockFontSize: 42
    property color labelColor: Kirigami.Theme.textColor

    spacing: 14

    ColumnLayout {
        Layout.alignment: Qt.AlignTop
        spacing: 0

        PlasmaComponents.Label {
            Layout.alignment: Qt.AlignTop
            Layout.topMargin: 16
            font.family: "sans"
            font.weight: 100
            font.pixelSize: root.clockFontSize

            color: root.labelColor
            text: root.clockText
        }

        PlasmaComponents.Label {
            Layout.alignment: Qt.AlignTop
            Layout.bottomMargin: 12

            font.family: "sans"
            font.weight: 300
            font.pixelSize: 16
            color: root.labelColor
            text: root.dateText
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

        PlasmaComponents.ToolButton {
            id: monthTitleBtn
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            text: root.monthTitle
            font.pixelSize: 14
            font.weight: Font.Medium
            onClicked: root.monthTitleClicked()
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
                icon.name: "go-jump-today-symbolic"
                display: PlasmaComponents.AbstractButton.IconOnly
                onClicked: root.todayClicked()
            }

            PlasmaComponents.ToolButton {
                icon.name: "go-down-symbolic"
                display: PlasmaComponents.AbstractButton.IconOnly
                onClicked: root.nextMonth()
            }
        }
    }
}
