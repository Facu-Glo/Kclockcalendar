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

        PlasmaComponents.ToolButton {
            id: monthTitleBtn
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            text: root.monthTitle
            font.pixelSize: 14
            font.weight: Font.Medium
            font.family: "sans"
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
