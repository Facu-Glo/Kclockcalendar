import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents

Item {
    id: root

    property var backend
    property color highlightColor: Kirigami.Theme.highlightColor

    signal monthSelected(int month)

    ColumnLayout {
        anchors.fill: parent
        spacing: 8

        RowLayout {
            Layout.fillWidth: true

            PlasmaComponents.ToolButton {
                icon.name: "go-previous"
                display: PlasmaComponents.AbstractButton.IconOnly
                onClicked: if (backend) backend.goToYear(backend.year - 1)
            }

            Item {
                Layout.fillWidth: true
            }

            PlasmaComponents.Label {
                Layout.alignment: Qt.AlignVCenter
                font.pixelSize: 14
                font.weight: Font.Medium
                horizontalAlignment: Text.AlignHCenter
                text: backend ? backend.year : ""
            }

            Item {
                Layout.fillWidth: true
            }

            PlasmaComponents.ToolButton {
                icon.name: "go-next"
                display: PlasmaComponents.AbstractButton.IconOnly
                onClicked: if (backend) backend.goToYear(backend.year + 1)
            }
        }

        Grid {
            id: monthsGrid
            Layout.fillWidth: true
            Layout.fillHeight: true

            columns: 3
            rows: 4
            rowSpacing: 6
            columnSpacing: 6

            readonly property real cellWidth: (width - (columns - 1) * columnSpacing) / columns
            readonly property real cellHeight: (height - (rows - 1) * rowSpacing) / rows

            Repeater {
                model: 12

                PlasmaComponents.AbstractButton {
                    required property int index

                    width: monthsGrid.cellWidth
                    height: monthsGrid.cellHeight
                    hoverEnabled: true

                    readonly property int monthNumber: index + 1

                    readonly property bool isCurrentMonth: {
                        return backend && backend.month === monthNumber
                    }

                    onClicked: root.monthSelected(monthNumber)

                    Rectangle {
                        anchors.fill: parent
                        radius: 6

                        color: {
                            if (parent.isCurrentMonth) return Qt.alpha(root.highlightColor, 0.25)
                            if (parent.hovered) return Qt.alpha(root.highlightColor, 0.15)
                            return "transparent"
                        }

                        border.width: (parent.isCurrentMonth || parent.hovered) ? 1 : 0
                        border.color: parent.hovered ? Qt.alpha(root.highlightColor, 0.4) : root.highlightColor
                    }

                    contentItem: PlasmaComponents.Label {
                        text: Qt.locale().toString(new Date(2000, index, 1), "MMM")
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: 13
                        font.weight: parent.isCurrentMonth ? Font.Bold : Font.Normal
                        color: Kirigami.Theme.textColor
                    }
                }
            }
        }
    }
}
