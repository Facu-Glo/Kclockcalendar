import QtQuick

Item {
    id: root

    property bool showSeconds: true
    property bool showPopupSeconds: false
    property bool expanded: false

    property date now: new Date()
    property date day: new Date()

    readonly property int clockInterval: {
        if (root.showSeconds) return 1000
        if (root.showPopupSeconds && root.expanded) return 1000
        return 60000
    }

    function updateNow() {
        var now = new Date()
        root.now = now
        if (now.getFullYear() !== root.day.getFullYear()
                || now.getMonth() !== root.day.getMonth()
                || now.getDate() !== root.day.getDate()) {
            root.day = now
        }
    }

    function armClockTimer() {
        var now = new Date()
        var interval = root.clockInterval
        if (interval === 1000) {
            clockTimer.interval = 1000 - now.getMilliseconds() + 5
        } else {
            clockTimer.interval = (60 - now.getSeconds()) * 1000 - now.getMilliseconds() + 5
        }
        clockTimer.start()
    }

    Timer {
        id: clockTimer
        repeat: false
        onTriggered: {
            root.updateNow()
            root.armClockTimer()
        }
    }

    Connections {
        target: root
        function onShowSecondsChanged() { root.armClockTimer() }
        function onShowPopupSecondsChanged() { root.armClockTimer() }
        function onExpandedChanged() { root.armClockTimer() }
    }

    Component.onCompleted: {
        root.updateNow()
        root.armClockTimer()
    }
}
