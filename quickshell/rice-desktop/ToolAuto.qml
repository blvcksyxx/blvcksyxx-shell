import Quickshell
import Quickshell.Io
import QtQuick

// Toolbox > Auto: local text actions with Ollama: summarize, translate Russian and English, pull out
// dates and tasks, or read the text of a picture (tesseract, English and Russian). Nothing leaves the
// computer; the text is only sent to Ollama on localhost.
Item {
    id: au
    property var pal
    property real enter: 1
    function e(i) { const p = Math.max(0, Math.min(1, (enter - i * 0.07) / 0.6)); return 1 - Math.pow(1 - p, 4) }
    property bool active: false
    property bool busy: false
    property string err: ""
    property string out: ""
    property string mode: ""
    readonly property string tool: "\"$HOME/.local/bin/rice-tools\""
    readonly property string summary: busy ? Tr.t("Working on it ...") : Tr.t("Summarize, translate, extract")

    onActiveChanged: if (active && input.text === "" && out === "") paste.running = true
    function focusIt() { input.forceActiveFocus() }
    function run(m) {
        if (busy || input.text.trim() === "") { input.forceActiveFocus(); return }
        busy = true; err = ""; out = ""; mode = m
        autoProc.command = ["bash", "-c", "printf '%s' \"$1\" | " + au.tool + " ai auto \"$2\"", "_", input.text, m]
        autoProc.running = true
    }
    function loadClipboard() { if (!paste.running) paste.running = true }
    function copyOut() { if (out !== "") Quickshell.execDetached(["bash", "-c", "printf %s \"$1\" | wl-copy", "_", out]) }
    function ocr() {
        if (busy) return
        busy = true; err = ""; out = ""; mode = "ocr"
        ocrProc.command = ["bash", "-c", "f=$(zenity --file-selection --title=\"$1\" --file-filter=\"Images | *.png *.jpg *.jpeg *.webp *.bmp *.tiff\" 2>/dev/null) || exit 0; " + au.tool + " ai ocr \"$f\"", "_", Tr.t("Text from a picture")]
        ocrProc.running = true
    }
    Process {
        id: paste
        command: ["bash", "-c", "wl-paste --no-newline 2>/dev/null || xclip -selection clipboard -o 2>/dev/null || true"]
        stdout: StdioCollector { onStreamFinished: if (text !== "" && input.text === "") input.text = text }
    }
    Process {
        id: autoProc
        stdout: SplitParser {
            onRead: function(line) {
                let j = null
                try { j = JSON.parse(line) } catch (e) { return }
                if (j.t) au.out += j.t
                else if (j.err) au.err = j.err
            }
        }
        onExited: au.busy = false
    }
    Process {
        id: ocrProc
        stdout: StdioCollector {
            onStreamFinished: {
                let j = null
                try { j = JSON.parse(text) } catch (e) { }
                if (j && j.t) au.out = j.t
                else au.err = (j && j.err) ? j.err : Tr.t("No text came back")
                au.busy = false
            }
        }
        onExited: if (au.busy) au.busy = false
    }

    // ---------------- the text to work on ----------------
    Rectangle {
        id: inCard
        width: parent.width; height: 150
        opacity: au.e(0); transform: Translate { y: (1 - au.e(0)) * 22 }
        radius: 22; color: au.pal.card
        border.width: 2; border.color: input.activeFocus ? au.pal.primary : "transparent"
        Behavior on border.color { ColorAnimation { duration: 180 } }
        Flickable {
            id: inf
            anchors.fill: parent; anchors.margins: 14
            contentHeight: input.implicitHeight; clip: true; boundsBehavior: Flickable.StopAtBounds
            TextEdit {
                id: input
                width: inf.width; height: Math.max(inf.height, implicitHeight)
                wrapMode: TextEdit.Wrap; selectByMouse: true
                color: au.pal.fg; selectionColor: au.pal.primary; selectedTextColor: au.pal.inkPrimary
                font.family: Fonts.main; font.pixelSize: 13
                Text { visible: input.text === ""; width: inf.width; wrapMode: Text.Wrap
                    text: Tr.t("Paste text here, or use the clipboard. Then pick what to do below.")
                    color: au.pal.dim; font: input.font }
            }
        }
    }
    Row {
        id: sources
        y: inCard.height + 8; width: parent.width; spacing: 6
        opacity: au.e(1); transform: Translate { y: (1 - au.e(1)) * 22 }
        ToolBtn { pal: au.pal; h: 32; label: Tr.t("Clipboard"); onClicked: au.loadClipboard() }
        ToolBtn { pal: au.pal; h: 32; label: Tr.t("Clear"); onClicked: { input.text = ""; au.out = ""; au.err = ""; input.forceActiveFocus() } }
        ToolBtn { pal: au.pal; h: 32; label: Tr.t("Text from a picture"); onClicked: au.ocr() }
    }

    // ---------------- the actions ----------------
    Flow {
        id: acts
        y: sources.y + sources.height + 12; width: parent.width; spacing: 6
        opacity: au.e(2); transform: Translate { y: (1 - au.e(2)) * 22 }
        ToolBtn { pal: au.pal; h: 36; label: Tr.t("Summarize"); onClicked: au.run("summarize") }
        ToolBtn { pal: au.pal; h: 36; label: "RU → EN"; onClicked: au.run("translate-en") }
        ToolBtn { pal: au.pal; h: 36; label: "EN → RU"; onClicked: au.run("translate-ru") }
        ToolBtn { pal: au.pal; h: 36; label: Tr.t("Extract facts"); onClicked: au.run("extract") }
        ToolBtn { pal: au.pal; h: 36; label: Tr.t("Make tasks"); onClicked: au.run("tasks") }
    }

    // ---------------- the answer ----------------
    Rectangle {
        id: resCard
        y: acts.y + acts.height + 14
        width: parent.width; height: Math.max(0, parent.height - y)
        visible: height > 1
        opacity: au.e(3); transform: Translate { y: (1 - au.e(3)) * 22 }
        radius: 22; color: au.pal.card
        Flickable {
            id: outf
            anchors.fill: parent; anchors.margins: 14
            contentHeight: outText.implicitHeight; clip: true; boundsBehavior: Flickable.StopAtBounds
            TextEdit {
                id: outText
                width: outf.width
                text: au.out
                readOnly: true; selectByMouse: true; wrapMode: TextEdit.Wrap
                color: au.pal.fg; selectionColor: au.pal.primary; selectedTextColor: au.pal.inkPrimary
                font.family: Fonts.main; font.pixelSize: 13
                visible: au.out !== ""
            }
            Text { visible: au.out === "" && au.err === ""; width: outf.width; wrapMode: Text.Wrap
                text: au.busy ? Tr.t("Thinking on this computer ...") : Tr.t("The answer appears here. It is not saved anywhere.")
                color: au.pal.dim; font.family: Fonts.main; font.pixelSize: 12 }
            Text { visible: au.err !== ""; width: outf.width; wrapMode: Text.Wrap
                text: au.err; color: "#ff9a9a"; font.family: Fonts.main; font.pixelSize: 12 }
        }
        Row {
            anchors.right: parent.right; anchors.top: parent.top; anchors.margins: 10; spacing: 4
            visible: au.out !== ""
            ToolBtn { pal: au.pal; h: 30; kind: "plain"; label: Tr.t("Copy"); onClicked: au.copyOut() }
            ToolBtn { pal: au.pal; h: 30; kind: "plain"; label: Tr.t("Into the note"); onClicked: {
                Quickshell.execDetached(["bash", "-c", "mkdir -p \"$HOME/.config/rice\" && printf '\\n\\n%s\\n' \"$1\" >> \"$HOME/.config/rice/note.txt\"", "_", au.out])
            } }
        }
    }
}
