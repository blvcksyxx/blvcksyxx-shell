import Quickshell
import Quickshell.Io
import QtQuick

// Toolbox > Games: the games that are already installed, from Steam, Lutris and the applications menu.
// rice-games reads their own files; a click starts one. Nothing is downloaded and nothing leaves the computer.
Item {
    id: gm
    property var pal
    property real enter: 1
    function e(i) { const p = Math.max(0, Math.min(1, (enter - i * 0.07) / 0.6)); return 1 - Math.pow(1 - p, 4) }
    property bool active: false
    property var games: []
    property var counts: ({})
    property string query: ""
    property string status: ""
    property bool loading: false
    readonly property var shown: {
        const q = query.trim().toLowerCase()
        return q === "" ? games : games.filter(function(g) { return String(g.name).toLowerCase().indexOf(q) >= 0 || String(g.source).toLowerCase().indexOf(q) >= 0 })
    }
    readonly property string summary: games.length === 0 ? Tr.t("No games found") : games.length + " " + Tr.t("games")
    onActiveChanged: if (active && games.length === 0) Qt.callLater(gm.refresh)
    function refresh() { if (!listProc.running) { loading = true; listProc.running = true } }
    function play(id) {
        status = ""
        launchProc.command = ["bash", "-c", "\"$HOME/.local/bin/rice-games\" launch \"$1\"", "_", id]
        launchProc.running = true
    }
    Process {
        id: listProc
        command: ["bash", "-c", "\"$HOME/.local/bin/rice-games\" list 2>/dev/null"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const j = JSON.parse(text)
                    gm.games = Array.isArray(j.games) ? j.games : []
                    gm.counts = j.counts || ({})
                } catch (e) { gm.games = [] }
                gm.loading = false
            }
        }
        onExited: gm.loading = false
    }
    Process {
        id: launchProc
        stdout: StdioCollector {
            onStreamFinished: {
                try { const j = JSON.parse(text); if (!j.ok) gm.status = j.error || Tr.t("It did not start") }
                catch (e) { }
            }
        }
    }
    Timer { interval: 90000; repeat: true; running: gm.active; onTriggered: gm.refresh() }

    ToolField {
        id: search
        pal: gm.pal; width: parent.width; hint: Tr.t("Search your games ..."); icon: "search"; glyph: String.fromCodePoint(0xF0349)
        opacity: gm.e(0); transform: Translate { y: (1 - gm.e(0)) * 22 }
        onEdited: gm.query = text
    }
    Item {
        id: head
        y: search.height + 8; width: parent.width; height: 30
        opacity: gm.e(1); transform: Translate { y: (1 - gm.e(1)) * 22 }
        Text { anchors.left: parent.left; anchors.right: refresh.left; anchors.rightMargin: 8; anchors.verticalCenter: parent.verticalCenter
            elide: Text.ElideRight; color: gm.pal.dim; font.family: Fonts.main; font.pixelSize: 12
            text: gm.loading ? Tr.t("Looking for games ...") : (gm.games.length === 0 ? "" : gm.games.length + " " + Tr.t("games") + " · " + ["Steam", "Lutris", "Menu"].filter(function(k) { return gm.counts[k] > 0 }).map(function(k) { return k + " " + gm.counts[k] }).join(" · ")) }
        ToolBtn { id: refresh; pal: gm.pal; h: 30; kind: "plain"; label: Tr.t("Refresh"); anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter; onClicked: gm.refresh() }
    }
    Flickable {
        id: fl
        y: head.y + head.height + 10; width: parent.width; height: parent.height - y - (status.text !== "" ? 24 : 0)
        opacity: gm.e(2); transform: Translate { y: (1 - gm.e(2)) * 22 }
        contentHeight: col.height; clip: true; boundsBehavior: Flickable.StopAtBounds
        Column {
            id: col
            width: parent.width; spacing: 6
            Repeater {
                model: gm.shown
                delegate: Rectangle {
                    id: row
                    required property var modelData
                    required property int index
                    width: col.width; height: 64
                    radius: hover.hovered ? 16 : 20
                    Behavior on radius { NumberAnimation { duration: 160 } }
                    color: hover.hovered ? gm.pal.cardHi : gm.pal.card
                    Behavior on color { ColorAnimation { duration: 140 } }
                    // the cover, or the first letter when there is none
                    Rectangle {
                        x: 10; anchors.verticalCenter: parent.verticalCenter
                        width: 44; height: 44; radius: 12
                        color: gm.pal.container; clip: true
                        Image { anchors.fill: parent; source: row.modelData.icon ? "file://" + row.modelData.icon : ""; fillMode: Image.PreserveAspectCrop
                            asynchronous: true; visible: status === Image.Ready }
                        Text { anchors.centerIn: parent; visible: !row.modelData.icon; text: String(row.modelData.name || "?").charAt(0).toUpperCase()
                            color: gm.pal.inkContainer; font.family: Fonts.main; font.pixelSize: 19; font.weight: Font.DemiBold }
                    }
                    Column {
                        x: 66; anchors.verticalCenter: parent.verticalCenter; width: parent.width - x - 58; spacing: 2
                        Text { width: parent.width; text: row.modelData.name; elide: Text.ElideRight
                            color: gm.pal.fg; font.family: Fonts.main; font.pixelSize: 14; font.weight: Font.DemiBold }
                        Text { width: parent.width; text: row.modelData.source + (row.modelData.extra ? " · " + row.modelData.extra : ""); elide: Text.ElideRight
                            color: gm.pal.dim; font.family: Fonts.main; font.pixelSize: 11 }
                    }
                    Rectangle {
                        width: 38; height: 38; radius: 19; anchors.right: parent.right; anchors.rightMargin: 10; anchors.verticalCenter: parent.verticalCenter
                        color: pm.containsMouse ? Qt.lighter(gm.pal.primary, 1.08) : gm.pal.primary
                        MIcon { anchors.centerIn: parent; size: 18; name: "play_arrow"; glyph: String.fromCodePoint(0xF040A); color: gm.pal.inkPrimary }
                        MouseArea { id: pm; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                            onClicked: gm.play(row.modelData.id) }
                    }
                    HoverHandler { id: hover }
                }
            }
        }
        Column {
            visible: gm.games.length === 0 && !gm.loading
            anchors.horizontalCenter: parent.horizontalCenter; y: 50; spacing: 10; width: parent.width - 30
            Rectangle { anchors.horizontalCenter: parent.horizontalCenter; width: 72; height: 72; radius: 26; color: gm.pal.container
                MIcon { anchors.centerIn: parent; size: 32; name: "sports_esports"; glyph: String.fromCodePoint(0xF02FA); color: gm.pal.inkContainer } }
            Text { anchors.horizontalCenter: parent.horizontalCenter; text: Tr.t("No games found"); color: gm.pal.fg; font.family: Fonts.main; font.pixelSize: 15; font.weight: Font.DemiBold }
            Text { width: parent.width; horizontalAlignment: Text.AlignHCenter; wrapMode: Text.Wrap; color: gm.pal.dim; font.family: Fonts.main; font.pixelSize: 12
                text: Tr.t("Install Steam or Lutris, or add a game to the applications menu, then press Refresh.") }
        }
    }
    Text {
        id: status
        anchors.bottom: parent.bottom; width: parent.width; height: 20
        text: gm.status; visible: gm.status !== ""; color: "#ff9a9a"; font.family: Fonts.main; font.pixelSize: 11; elide: Text.ElideRight
        opacity: gm.e(3)
    }
}
