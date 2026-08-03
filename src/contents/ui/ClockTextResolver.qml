import QtQuick

QtObject {
    id: root

    property date now: new Date()
    property date day: new Date()
    property string timeFormat: "HH:mm:ss"
    property string dateFormat: "dd/MM/yy"

    function timeIs12h(): bool {
        return root.timeFormat.includes("ap") || root.timeFormat.includes("AP")
    }

    function timeHasSeconds(): bool {
        return root.timeFormat.includes("s")
    }

    function hourText(): string {
        if (root.timeIs12h()) {
            const h = root.now.getHours() % 12 || 12
            const text = String(h)
            return root.timeFormat.includes("hh") ? text.padStart(2, "0") : text
        }
        const leading = root.timeFormat.includes("HH")
        return Qt.locale().toString(root.now, leading ? "HH" : "H")
    }

    function minuteText(): string {
        return Qt.locale().toString(root.now, root.timeFormat.includes("mm") ? "mm" : "m")
    }

    function ampmText(): string {
        if (!root.timeIs12h()) return ""
        const ap = root.timeFormat.includes("ap") ? "ap" : "AP"
        return Qt.locale().toString(root.now, ap)
    }

    function secondText(): string {
        if (!root.timeHasSeconds()) return ""
        return Qt.locale().toString(root.now, root.timeFormat.includes("ss") ? "ss" : "s")
    }

    function fullTimeText(): string {
        return Qt.locale().toString(root.now, root.timeFormat)
    }

    function fullDateText(): string {
        return Qt.locale().toString(root.day, root.dateFormat)
    }

    function splitDateFormat() {
        const f = root.dateFormat
        if (f.includes("MMMM")) {
            const idx = f.indexOf("MMMM")
            return { before: f.slice(0, idx), after: f.slice(idx + 4), month: "MMMM" }
        }
        if (f.includes("MMM")) {
            const idx = f.indexOf("MMM")
            return { before: f.slice(0, idx), after: f.slice(idx + 3), month: "MMM" }
        }
        return { before: f, after: "", month: "" }
    }

    function dateMainText(): string {
        const seg = root.splitDateFormat()
        if (!seg.month) return root.fullDateText()
        if (seg.before.trim() === "") return Qt.locale().toString(root.day, seg.after).trim()
        return Qt.locale().toString(root.day, seg.before).trim()
    }

    function dateMonthText(): string {
        const seg = root.splitDateFormat()
        if (!seg.month) return ""
        const month = Qt.locale().toString(root.day, seg.month).trim()
        if (seg.before.trim() === "") return month
        const tail = Qt.locale().toString(root.day, seg.after).trim()
        return [month, tail].filter(s => s !== "").join(" ")
    }
}
