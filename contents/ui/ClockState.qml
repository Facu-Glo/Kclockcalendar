import QtQuick

Item {
    id: root

    property bool showSeconds: true
    property bool showPopupSeconds: false
    property bool expanded: false

    property date now: new Date()
    property date day: new Date()

    function updateNow() {
        var n = new Date()
        root.now = n
        if (n.getFullYear() !== root.day.getFullYear()
                || n.getMonth() !== root.day.getMonth()
                || n.getDate() !== root.day.getDate()) {
            root.day = n
        }
    }

    function alignAndStartClock() {
        syncTimer.stop()
        clockTimer.stop()

        root.updateNow()

        var needsSeconds = root.showSeconds || (root.showPopupSeconds && root.expanded)
        var n = new Date()

        if (needsSeconds) {
            var msToNextSecond = 1000 - n.getMilliseconds()
            syncTimer.interval = Math.max(1, msToNextSecond)
            syncTimer.targetInterval = 1000
            syncTimer.start()
        } else {
            var msToNextMinute = (60 - n.getSeconds()) * 1000 - n.getMilliseconds()
            syncTimer.interval = Math.max(1, msToNextMinute)
            syncTimer.targetInterval = 60000
            syncTimer.start()
        }
    }

    Timer {
        id: syncTimer
        property int targetInterval: 1000
        repeat: false
        onTriggered: {
            root.updateNow()
            clockTimer.interval = targetInterval
            clockTimer.start()
        }
    }

    Timer {
        id: clockTimer
        repeat: true
        onTriggered: {
            root.updateNow()
        }
    }

    Connections {
        target: root
        function onShowSecondsChanged() { root.alignAndStartClock() }
        function onShowPopupSecondsChanged() { root.alignAndStartClock() }
        function onExpandedChanged() { root.alignAndStartClock() }
    }

    Component.onCompleted: {
        root.alignAndStartClock()
    }
}
