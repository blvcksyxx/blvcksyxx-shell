import Quickshell
import Quickshell.Io
import QtQuick

// Toolbox > Note: the same note as the Note widget on the desktop (~/.config/rice/note.txt), saved as you type.
// Markdown is written in Edit and seen in Preview; the buttons above the note add the markers for you.
Item {
    id: nt
    property var pal
    // the opening wave (Tools.qml): 0 .. 1; each part comes a moment after the one above it
    property real enter: 1
    function e(i) { const p = Math.max(0, Math.min(1, (enter - i * 0.07) / 0.6)); return 1 - Math.pow(1 - p, 4) }
    property bool active: false
    property bool loaded: false
    property bool saved: true
    property bool preview: false
    function focusIt() { if (!preview) edit.forceActiveFocus() }
    readonly property string summary: preview ? Tr.t("Preview · Markdown") : Tr.t("Markdown · saved as you type")
    readonly property int words: edit.text.trim() === "" ? 0 : edit.text.trim().split(/\s+/).filter(s => s !== "").length
    // Ctrl + P: write, then see it the way Markdown reads
    Shortcut { sequence: "Ctrl+P"; onActivated: nt.preview = !nt.preview }
    onActiveChanged: if (active && !edit.activeFocus) { loaded = false; load.running = true }

    // a change from the toolbar: shown at once, then written like a typed one
    function changed() {
        nt.saved = false
        save.restart()
        if (!nt.preview) edit.forceActiveFocus()
    }
    // put a pair of markers around what is selected (or leave the cursor between them)
    function wrap(a, b) {
        const t = edit.text, s = edit.selectionStart, e = edit.selectionEnd
        const sel = t.slice(s, e)
        edit.text = t.slice(0, s) + a + sel + b + t.slice(e)
        edit.cursorPosition = s + a.length + sel.length
        nt.changed()
    }
    // put a marker at the start of the line the cursor is on
    function prefix(p) {
        const t = edit.text, pos = edit.cursorPosition
        const ls = t.lastIndexOf("\n", pos - 1) + 1
        edit.text = t.slice(0, ls) + p + t.slice(ls)
        edit.cursorPosition = pos + p.length
        nt.changed()
    }
    function heading(level) {
        const t = edit.text, pos = edit.cursorPosition
        const ls = t.lastIndexOf("\n", pos - 1) + 1
        let le = t.indexOf("\n", pos)
        if (le < 0) le = t.length
        const line = t.slice(ls, le).replace(/^#{1,6}\s+/, "")
        const p = "#".repeat(level) + " "
        edit.text = t.slice(0, ls) + p + line + t.slice(le)
        edit.cursorPosition = ls + p.length + line.length
        nt.changed()
    }
    function box() {
        const t = edit.text, s = edit.selectionStart, e = edit.selectionEnd
        const first = t.lastIndexOf("\n", s - 1) + 1
        let last = t.indexOf("\n", e)
        if (last < 0) last = t.length
        const body = t.slice(first, last).split("\n").map(function(l) { return "- [ ] " + l.replace(/^(\s*[-*]\s*\[[ xX]\]\s*|\s*[-*]\s*)/, "") }).join("\n")
        edit.text = t.slice(0, first) + body + t.slice(last)
        edit.cursorPosition = first + body.length
        nt.changed()
    }

    Process {
        id: load
        command: ["bash", "-c", "cat \"$HOME/.config/rice/note.txt\" 2>/dev/null"]
        stdout: StdioCollector { onStreamFinished: { if (!nt.loaded) { edit.text = text.replace(/\n$/, ""); nt.loaded = true; nt.saved = true } } }
    }
    Timer {
        id: save
        interval: 600
        onTriggered: { Quickshell.execDetached(["bash", "-c", "mkdir -p \"$HOME/.config/rice\" && printf '%s\\n' \"$1\" > \"$HOME/.config/rice/note.txt\"", "_", edit.text]); nt.saved = true }
    }

    // ---------------- Edit / Preview, and the Markdown tools ----------------
    Flow {
        id: tools
        width: parent.width; spacing: 5
        opacity: nt.e(0); transform: Translate { y: (1 - nt.e(0)) * 22 }
        ToolBtn { pal: nt.pal; h: 34; label: Tr.t("Edit"); on: !nt.preview
            onClicked: { nt.preview = false; edit.forceActiveFocus() } }
        ToolBtn { pal: nt.pal; h: 34; label: Tr.t("Preview"); on: nt.preview
            onClicked: nt.preview = true }
        Item { width: 8; height: 1 }
        ToolBtn { pal: nt.pal; h: 34; kind: "plain"; visible: !nt.preview; label: "H1"; onClicked: nt.heading(1) }
        ToolBtn { pal: nt.pal; h: 34; kind: "plain"; visible: !nt.preview; label: "H2"; onClicked: nt.heading(2) }
        ToolBtn { pal: nt.pal; h: 34; kind: "plain"; visible: !nt.preview; icon: "format_bold"; glyph: String.fromCodePoint(0xF0264); onClicked: nt.wrap("**", "**") }
        ToolBtn { pal: nt.pal; h: 34; kind: "plain"; visible: !nt.preview; icon: "format_italic"; glyph: String.fromCodePoint(0xF0277); onClicked: nt.wrap("*", "*") }
        ToolBtn { pal: nt.pal; h: 34; kind: "plain"; visible: !nt.preview; icon: "format_list_bulleted"; glyph: String.fromCodePoint(0xF0279); onClicked: nt.prefix("- ") }
        ToolBtn { pal: nt.pal; h: 34; kind: "plain"; visible: !nt.preview; icon: "checklist"; glyph: String.fromCodePoint(0xF0135); onClicked: nt.box() }
        ToolBtn { pal: nt.pal; h: 34; kind: "plain"; visible: !nt.preview; icon: "format_quote"; glyph: String.fromCodePoint(0xF027E); onClicked: nt.prefix("> ") }
        ToolBtn { pal: nt.pal; h: 34; kind: "plain"; visible: !nt.preview; icon: "code"; glyph: String.fromCodePoint(0xF0174); onClicked: nt.wrap("`", "`") }
        ToolBtn { pal: nt.pal; h: 34; kind: "plain"; visible: !nt.preview; icon: "link"; glyph: String.fromCodePoint(0xF0337); onClicked: nt.wrap("[", "](https://)") }
    }

    Rectangle {
        id: card
        y: tools.height + 10
        width: parent.width; height: Math.max(40, parent.height - y - 30)
        opacity: nt.e(1); transform: Translate { y: (1 - nt.e(1)) * 22 }
        radius: edit.activeFocus && !nt.preview ? 20 : 26
        Behavior on radius { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }
        color: nt.pal.card
        border.width: 2; border.color: edit.activeFocus && !nt.preview ? nt.pal.primary : "transparent"
        Behavior on border.color { ColorAnimation { duration: 180 } }
        Flickable {
            id: fl
            anchors.fill: parent; anchors.margins: 16
            visible: !nt.preview
            contentHeight: edit.implicitHeight; clip: true; boundsBehavior: Flickable.StopAtBounds
            function follow(r) { if (r.y < contentY) contentY = r.y; else if (r.y + r.height > contentY + height) contentY = r.y + r.height - height }
            TextEdit {
                id: edit
                width: fl.width
                height: Math.max(fl.height, implicitHeight)
                wrapMode: TextEdit.Wrap; selectByMouse: true
                color: nt.pal.fg; selectionColor: nt.pal.primary; selectedTextColor: nt.pal.inkPrimary
                font.family: Fonts.main; font.pixelSize: 14
                onTextChanged: if (nt.loaded) { nt.saved = false; save.restart() }
                onCursorRectangleChanged: fl.follow(cursorRectangle)
                Text { visible: edit.text === ""; text: Tr.t("Write anything here. Markdown works: # heading, **bold**, - list, - [ ] to-do."); color: nt.pal.dim; font: edit.font; width: fl.width; wrapMode: Text.Wrap }
            }
        }
        Flickable {
            id: pv
            anchors.fill: parent; anchors.margins: 16
            visible: nt.preview
            contentHeight: view.implicitHeight; clip: true; boundsBehavior: Flickable.StopAtBounds
            Md {
                id: view
                width: pv.width
                height: Math.max(pv.height, implicitHeight)
                pal: nt.pal
                source: edit.text
            }
            Text { visible: edit.text === ""; text: Tr.t("Nothing to preview yet. Write something in Edit."); color: nt.pal.dim; font.family: Fonts.main; font.pixelSize: 14; width: pv.width; wrapMode: Text.Wrap }
        }
    }
    Row {
        anchors.bottom: parent.bottom; anchors.bottomMargin: 4; x: 6; spacing: 8
        opacity: nt.e(2); transform: Translate { y: (1 - nt.e(2)) * 22 }
        Rectangle { anchors.verticalCenter: parent.verticalCenter; width: 8; height: 8; radius: 4; color: nt.saved ? nt.pal.primary : nt.pal.dim
            Behavior on color { ColorAnimation { duration: 200 } } }
        Text { color: nt.pal.dim; font.family: Fonts.main; font.pixelSize: 12
            text: (nt.saved ? Tr.t("Saved") : Tr.t("Saving ...")) + "  ·  " + nt.words + " " + Tr.t("words") + "  ·  " + Tr.t("Markdown") }
    }
}
