import QtQuick

Item {
    id: root

    property string timeFormat: "HH:mm:ss"
    property string popupTimeFormat: "HH:mm:ss"
    property bool expanded: false

    function needsSeconds(): bool {
        return root.timeFormat.includes("s") || (root.expanded && root.popupTimeFormat.includes("s"))
    }

    property date now: new Date()
    property date today: new Date()

    function updateNow() {
        var n = new Date()
        root.now = n
        if (n.getFullYear() !== root.today.getFullYear()
                || n.getMonth() !== root.today.getMonth()
                || n.getDate() !== root.today.getDate()) {
            root.today = n
        }
    }

    function millisecondsToNextTick() {
        var n = new Date()
        if (root.needsSeconds())
            return Math.max(1, 1000 - n.getMilliseconds())
        return Math.max(1, (60 - n.getSeconds()) * 1000 - n.getMilliseconds())
    }

    function alignAndStartClock() {
        tickTimer.stop()
        root.updateNow()
        tickTimer.interval = root.millisecondsToNextTick()
        tickTimer.start()
    }

    Timer {
        id: tickTimer
        repeat: false
        onTriggered: root.alignAndStartClock()
    }

    Connections {
        target: root
        function onTimeFormatChanged() { root.alignAndStartClock() }
        function onPopupTimeFormatChanged() { root.alignAndStartClock() }
        function onExpandedChanged() { root.alignAndStartClock() }
    }

    Component.onCompleted: {
        root.alignAndStartClock()
    }
}
