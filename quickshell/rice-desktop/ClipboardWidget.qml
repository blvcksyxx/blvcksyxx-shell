import Quickshell
import Quickshell.Io
import QtQuick

// Clipboard history on the desktop: the newest things you copied (cliphist), pins first and the texts after them.
// Click an entry to put it back in the clipboard. Needs a click; the whole list is SUPER + V.
Item {
    id: cw
    property real bg: 1       // card background opacity (widget editor)
    property var pal: null
    property bool running: true
    property var items: []
    property var pins: []
    property bool ok: true
    property bool loaded: false
    property string flash: ""
    readonly property string tool: Quickshell.env("HOME") + "/.local/bin/rice-clip"
    readonly property color cFg: pal ? pal.fg : "#F6F5F4"
    readonly property color cFg3: pal ? pal.fg3 : "#8a8a8f"
    readonly property color cFg4: pal ? pal.fg4 : "#6a6a70"
    readonly property color cMain: pal ? pal.primary : "#F6F5F4"
    readonly property var shown: {
        const o = []
        for (let i = 0; i < Math.min(3, pins.length); i++) o.push({ kind: "pin", text: pins[i] })
        for (let i = 0; i < items.length && o.length < 8; i++) o.push(items[i])
        return o
    }
    readonly property int total: items.length + pins.length

    function run(a) { Quickshell.execDetached([cw.tool].concat(a)) }
    function pick(e) {
        if (!e) return
        run(e.kind === "pin" ? ["copy-text", e.text] : ["copy", String(e.id)])
        flash = Tr.t("Copied")
        flashT.restart()
    }
    Process {
        id: proc
        command: [cw.tool, "list", "30"]
        stdout: StdioCollector { onStreamFinished: {
            try {
                const j = JSON.parse(text)
                cw.items = Array.isArray(j.items) ? j.items : []
                cw.pins = Array.isArray(j.pins) ? j.pins : []
                cw.ok = j.ok !== false
            } catch (e) { cw.ok = false }
            cw.loaded = true
        } }
    }
    Timer { interval: 3000; running: cw.running && cw.visible; repeat: true; triggeredOnStart: true; onTriggered: if (!proc.running) proc.running = true }
    Timer { id: flashT; interval: 1200; onTriggered: cw.flash = "" }

    Card { anchors.fill: parent; k: cw.bg; pal: cw.pal }

    Row {
        id: head
        x: 22; y: 18
        spacing: 10
        Rectangle {
            width: 30; height: 30; radius: 15
            color: cw.pal ? cw.pal.chip : Qt.rgba(1, 1, 1, 0.08)
            T { kind: "icon"; anchors.centerIn: parent; text: "\uf0ea"; font.pixelSize: 14; color: cw.cMain }
        }
        T { text: Tr.t("Clipboard"); font.pixelSize: 17; font.bold: true; color: cw.cFg; anchors.verticalCenter: parent.verticalCenter }
    }
    T {
        anchors.right: parent.right; anchors.rightMargin: 22
        y: head.y + (30 - height) / 2
        text: cw.flash !== "" ? cw.flash : (cw.total > 0 ? cw.total + Tr.t(" copied") : "")
        font.pixelSize: 12; color: cw.flash !== "" ? cw.cMain : cw.cFg3
    }

    Flickable {
        id: fl
        x: 14; y: 60
        width: parent.width - 28
        height: parent.height - 60 - 40
        contentWidth: width
        contentHeight: list.height
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        Column {
            id: list
            width: fl.width
            Repeater {
                model: cw.shown
                delegate: Item {
                    id: row
                    required property var modelData
                    width: list.width
                    height: 34
                    Rectangle {
                        anchors.fill: parent
                        anchors.topMargin: 1; anchors.bottomMargin: 1
                        radius: 10
                        color: hover.containsMouse ? (cw.pal ? cw.pal.chip : Qt.rgba(1, 1, 1, 0.06)) : "transparent"
                    }
                    T {
                        id: ic
                        x: 8; anchors.verticalCenter: parent.verticalCenter
                        kind: "icon"; font.pixelSize: 12
                        text: row.modelData.kind === "pin" ? "\uf08d" : (row.modelData.kind === "image" ? "\uf03e" : "\uf0c1")
                        color: row.modelData.kind === "pin" ? cw.cMain : cw.cFg4
                    }
                    T {
                        anchors.left: ic.right; anchors.leftMargin: 10
                        anchors.right: parent.right; anchors.rightMargin: 10
                        anchors.verticalCenter: parent.verticalCenter
                        text: row.modelData.kind === "image" ? Tr.t("[picture]") : String(row.modelData.text || "").replace(/\s+/g, " ").trim()
                        font.pixelSize: 12
                        color: cw.cFg
                        elide: Text.ElideRight
                    }
                    MouseArea { id: hover; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                        onClicked: cw.pick(row.modelData) }
                }
            }
        }
        Column {
            visible: cw.loaded && cw.shown.length === 0
            width: fl.width; y: 10; spacing: 4
            T { width: parent.width; wrapMode: Text.Wrap; text: cw.ok ? Tr.t("Nothing copied yet") : Tr.t("cliphist is not installed, so the history is off")
                font.pixelSize: 13; color: cw.cFg3 }
            T { visible: cw.ok; width: parent.width; wrapMode: Text.Wrap; text: Tr.t("Copy something and it appears here.")
                font.pixelSize: 12; color: cw.cFg4 }
        }
    }
    T {
        anchors.left: parent.left; anchors.leftMargin: 22; anchors.bottom: parent.bottom; anchors.bottomMargin: 12
        text: Tr.t("Click to copy · SUPER + V for everything")
        font.pixelSize: 11; color: cw.cFg4
    }
}
