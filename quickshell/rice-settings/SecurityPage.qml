import Quickshell
import Quickshell.Io
import QtQuick

// Settings > Security: a virus scan (ClamAV), a look at the system, a watch on the shell's own files, and
// an experimental switch (hardening). Everything is done by rice-security; what needs root
// opens a terminal with the command, so you see it and type your password there.
Item {
    id: page
    property var ctl
    readonly property bool niri: !!Quickshell.env("NIRI_SOCKET")
    property var sec: ({ clam: {}, last: {}, progress: {}, quarantine: [], checks: [], integrity: {}, hardening: {} })
    property bool experimental: false

    readonly property var prog: sec.progress || ({})
    readonly property bool scanning: prog.running === true
    readonly property var found: prog.found || []
    readonly property int bad: (sec.checks || []).filter(c => !c.ok).length
    readonly property var integ: sec.integrity || ({})
    readonly property int changed: (integ.changed ? integ.changed.length : 0) + (integ.new ? integ.new.length : 0)
    readonly property int attention: found.length + changed
    readonly property var priv: sec.privacy || ({ mic: [], camera: [], screen: [], geo: [], dns: {}, firewall: {}, clipboard: {}, autolock: {}, apps: [] })
    readonly property int watching: (priv.mic || []).length + (priv.camera || []).length + (priv.screen || []).length
    function reach(a) {
        return (a.reach || []).map(function(k) { return k === "mic" ? I18n.t("Microphone") : k === "camera" ? I18n.t("Camera") : k === "files" ? I18n.t("Files") : I18n.t("Network") }).join(" · ")
    }
    function lockNow() { Quickshell.execDetached(["bash", "-c", "\"$HOME/.local/bin/rice-lock\" now"]) }

    function sh(args) { runner.command = ["bash", "-c", "\"$HOME/.local/bin/rice-security\" \"$@\" 2>&1", "_"].concat(args); runner.running = true }
    function term(cmd) { Quickshell.execDetached(["bash", "-c", "\"$HOME/.local/bin/rice-security\" term \"$1\"", "_", cmd]) }
    function ago(t) {
        if (!t) return ""
        const s = Math.max(0, Date.now() / 1000 - t)
        if (s < 90) return I18n.t("just now")
        if (s < 5400) return Math.round(s / 60) + " min"
        if (s < 129600) return Math.round(s / 3600) + " h"
        return Math.round(s / 86400) + " d"
    }
    Process {
        id: stateProc
        command: ["bash", "-c", "\"$HOME/.local/bin/rice-security\" state"]
        running: true
        stdout: StdioCollector { onStreamFinished: { try { page.sec = JSON.parse(text) } catch (e) { } } }
    }
    Process {
        id: progProc
        command: ["bash", "-c", "\"$HOME/.local/bin/rice-security\" progress"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const p = JSON.parse(text), was = page.scanning
                    const n = Object.assign({}, page.sec); n.progress = p; page.sec = n
                    if (was && p.running === false) stateProc.running = true
                } catch (e) { }
            }
        }
    }
    Process {
        id: runner
        stdout: StdioCollector { onStreamFinished: { stateProc.running = true } }
    }
    Timer { interval: 1000; running: page.visible && page.scanning; repeat: true; onTriggered: if (!progProc.running) progProc.running = true }
    Timer { interval: 8000; running: page.visible && !page.scanning; repeat: true; onTriggered: if (!stateProc.running) stateProc.running = true }
    onVisibleChanged: if (visible) stateProc.running = true

    // one line of a list: icon, name, text, and a button when there is one
    component Row3: Rectangle {
        id: r
        property string sym: "check_circle"
        property string glyph: ""
        property bool warn: false
        property string label: ""
        property string desc: ""
        property string btn: ""
        property string btnVariant: "tonal"
        signal clicked()
        width: parent ? parent.width : 400
        height: Math.max(60, tcol.implicitHeight + 20)
        radius: M3.rM
        color: hov.hovered ? M3.surfaceHigh : M3.surfaceC
        HoverHandler { id: hov }
        Rectangle { x: 14; anchors.verticalCenter: parent.verticalCenter; width: 36; height: 36; radius: 18
            color: r.warn ? M3.errorContainer : M3.secondaryContainer
            Icon { anchors.centerIn: parent; name: r.sym; glyph: r.glyph; size: 18; color: r.warn ? M3.inkErrorC : M3.inkSecondaryC } }
        Column {
            id: tcol
            x: 62; anchors.verticalCenter: parent.verticalCenter
            width: parent.width - 62 - (r.btn !== "" ? bt.width + 28 : 16)
            spacing: 2
            T { text: r.label; font.pixelSize: 14; font.weight: Font.Medium; width: parent.width; elide: Text.ElideRight }
            T { kind: "reading"; visible: r.desc !== ""; text: r.desc; color: M3.inkDim; font.pixelSize: 12; width: parent.width; wrapMode: Text.WordWrap; maximumLineCount: 3; elide: Text.ElideRight }
        }
        Btn { id: bt; visible: r.btn !== ""; text: r.btn; variant: r.btnVariant; anchors.right: parent.right; anchors.rightMargin: 14; anchors.verticalCenter: parent.verticalCenter
            height: 36; onClicked: r.clicked() }
    }

    PageScroll {
        anchors.fill: parent

        // ---------- the state of things ----------
        Rectangle {
            width: parent.width
            height: 150
            radius: M3.rXL
            color: page.attention > 0 ? M3.errorContainer : M3.primaryContainer
            clip: true
            Blob { width: 240; height: 240; x: parent.width - 170; y: -60; kind: "flower"; color: M3.alpha(page.attention > 0 ? M3.inkErrorC : M3.inkPrimaryC, 0.06) }
            Icon { x: 24; y: 22; name: "shield"; glyph: ""; size: 20; color: M3.alpha(page.attention > 0 ? M3.inkErrorC : M3.inkPrimaryC, 0.8) }
            T { x: 54; y: 22; text: I18n.t("SECURITY"); font.pixelSize: 11; font.weight: Font.DemiBold; font.letterSpacing: 1.2
                color: M3.alpha(page.attention > 0 ? M3.inkErrorC : M3.inkPrimaryC, 0.8) }
            T { x: 24; y: 48; kind: "title"; font.pixelSize: 26; font.weight: Font.Medium; width: parent.width - 48; elide: Text.ElideRight
                color: page.attention > 0 ? M3.inkErrorC : M3.inkPrimaryC
                text: page.found.length > 0 ? (page.found.length + " " + I18n.t("threat(s) found")) : (page.changed > 0 ? I18n.t("Shell files changed") : (page.bad > 0 ? page.bad + " " + I18n.t("thing(s) to look at") : I18n.t("Looks good"))) }
            T { x: 24; y: 92; kind: "reading"; font.pixelSize: 13; width: parent.width - 48; wrapMode: Text.WordWrap; maximumLineCount: 2
                color: M3.alpha(page.attention > 0 ? M3.inkErrorC : M3.inkPrimaryC, 0.85)
                text: page.sec.last && page.sec.last.when ? I18n.t("Last virus scan") + ": " + page.ago(page.sec.last.when) + " · " + page.sec.last.files + " " + I18n.t("files") : I18n.t("No virus scan yet. Start one below.") }
        }

        // ---------- privacy: who is using the microphone, camera and screen, and the network switches ----------
        SectionTitle { text: I18n.t("Privacy"); sub: I18n.t("Who is using your microphone, camera or screen right now, and what the network does. Nothing here is stored or sent anywhere.") }
        Row3 {
            warn: page.watching > 0
            sym: page.watching > 0 ? "visibility" : "check_circle"; glyph: page.watching > 0 ? "\uf06e" : "\uf058"
            label: page.watching > 0 ? page.watching + " " + I18n.t("app(s) are using a device") : I18n.t("Nothing is watching or listening")
            desc: (priv.mic || []).length + " " + I18n.t("microphone") + " · " + (priv.camera || []).length + " " + I18n.t("camera") + " · " + (priv.screen || []).length + " " + I18n.t("screen")
            btn: (priv.mic || []).length > 0 ? (priv.mic_muted ? I18n.t("Unmute") : I18n.t("Mute microphone")) : ""
            btnVariant: "tonal"
            onClicked: page.sh(["mic-mute"])
        }
        Repeater {
            model: (priv.mic || []).concat(priv.camera || []).concat(priv.screen || [])
            delegate: Row3 {
                required property var modelData
                required property int index
                readonly property bool mic: index < (page.priv.mic || []).length
                readonly property bool cam: !mic && index < (page.priv.mic || []).length + (page.priv.camera || []).length
                sym: mic ? "mic" : (cam ? "photo_camera" : "screen_share"); glyph: mic ? "\uf130" : (cam ? "\uf030" : "\uf0c2")
                label: modelData.app || "?"
                desc: (mic ? I18n.t("Microphone") : (cam ? I18n.t("Camera") + (modelData.device ? " · " + modelData.device : "") : I18n.t("Screen"))) + (modelData.pid ? " · PID " + modelData.pid : "")
            }
        }
        Row3 {
            warn: (priv.geo || []).length > 0
            sym: "location_on"; glyph: "\uf03e"
            label: (priv.geo || []).length > 0 ? (priv.geo || []).length + " " + I18n.t("app(s) asked for your location") : I18n.t("Location is not in use")
            desc: I18n.t("Apps get your location only through the system portal, and only while they ask for it.")
        }
        Row3 {
            warn: !(priv.autolock && priv.autolock.on)
            sym: "lock"; glyph: "\uf023"
            label: (priv.autolock && priv.autolock.on) ? I18n.t("Locks after %1 min").replace("%1", priv.autolock.minutes) : I18n.t("The screen does not lock by itself")
            desc: I18n.t("SUPER + L locks it now. The timer, sleep and the look of the lock screen are in Idle & Lockscreen.")
            btn: I18n.t("Lock now"); btnVariant: "filled"
            onClicked: page.lockNow()
        }
        SettingRow {
            label: I18n.t("Autolock")
            desc: I18n.t("How long you can be away before the screen locks, and whether it locks before sleep")
            reserved: 250
            Btn { anchors.right: parent.right; anchors.rightMargin: 12; anchors.verticalCenter: parent.verticalCenter
                text: I18n.t("Idle & Lockscreen"); variant: "tonal"; onClicked: page.ctl.page = 11 }
        }
        Row3 {
            warn: !(priv.clipboard && priv.clipboard.available)
            sym: "content_paste"; glyph: "\uf0ea"
            label: I18n.t("Clipboard history")
            desc: priv.clipboard && priv.clipboard.available ? (priv.clipboard.entries + " " + I18n.t("entries") + " · " + I18n.t("pinned items stay when you clear it")) : I18n.t("cliphist is not installed, so the history is off")
            btn: priv.clipboard && priv.clipboard.available && priv.clipboard.entries > 0 ? I18n.t("Clear history") : ""
            btnVariant: "danger"
            onClicked: page.sh(["clipboard-clear"])
        }
        SettingRow {
            label: I18n.t("Private DNS")
            desc: (priv.dns && priv.dns.current ? I18n.t("Now") + ": " + priv.dns.current + ". " : "") + I18n.t("Encrypted name lookups through systemd-resolved. Opens a terminal for the password.")
            reserved: 330
            Row {
                anchors.right: parent.right; anchors.rightMargin: 12; anchors.verticalCenter: parent.verticalCenter; spacing: 6
                Btn { text: I18n.t("Off"); variant: (page.priv.dns || {}).preset === "off" ? "filled" : "tonal"; onClicked: page.term(page.priv.dns.cmds.off) }
                Btn { text: "Cloudflare"; variant: (page.priv.dns || {}).preset === "cloudflare" ? "filled" : "tonal"; onClicked: page.term(page.priv.dns.cmds.cloudflare) }
                Btn { text: "Quad9"; variant: (page.priv.dns || {}).preset === "quad9" ? "filled" : "tonal"; onClicked: page.term(page.priv.dns.cmds.quad9) }
            }
        }
        Row3 {
            warn: !(priv.firewall && priv.firewall.on)
            sym: "firewall"; glyph: "\uf1e8"
            label: (priv.firewall && priv.firewall.on) ? I18n.t("Firewall is on") : I18n.t("Firewall is off")
            desc: (priv.firewall && priv.firewall.service) ? I18n.t("Service") + ": " + priv.firewall.service : I18n.t("A simple switch for ufw or firewalld. Opens a terminal for the password.")
            btn: (priv.firewall && priv.firewall.on) ? I18n.t("Turn off") : I18n.t("Turn on")
            btnVariant: (priv.firewall && priv.firewall.on) ? "tonal" : "filled"
            onClicked: page.term((priv.firewall && priv.firewall.on) ? priv.firewall.off_cmd : priv.firewall.on_cmd)
        }

        // ---------- app permissions: what installed Flatpak apps may reach ----------
        SectionTitle { text: I18n.t("App permissions"); sub: I18n.t("Installed Flatpak apps and the broad things they may reach. Flatseal changes them with switches; nothing here is changed by itself.") }
        Repeater {
            model: page.priv.apps || []
            delegate: Row3 {
                required property var modelData
                warn: modelData.wide === true
                sym: "apps"; glyph: "\uf085"
                label: modelData.name
                desc: page.reach(modelData) !== "" ? page.reach(modelData) : I18n.t("No broad access")
                btn: I18n.t("Permissions")
                onClicked: page.term(modelData.cmd)
            }
        }
        Row3 {
            visible: (page.priv.apps || []).length === 0
            sym: "apps"; glyph: "\uf085"
            label: I18n.t("No Flatpak apps installed")
            desc: I18n.t("Flatpak apps keep their permissions in one place, so they can be shown and changed here. Other programs use the system directly.")
        }

        // ---------- virus scan ----------
        SectionTitle { text: I18n.t("Virus scan"); sub: I18n.t("ClamAV looks for known viruses in your files. Linux has few, but files you share with Windows can carry them.") }

        Row3 {
            visible: !page.sec.clam || !page.sec.clam.installed
            sym: "download"; glyph: ""
            label: I18n.t("ClamAV is not installed")
            desc: I18n.t("It opens a terminal with the command; you type your password there.")
            btn: I18n.t("Install"); btnVariant: "filled"
            onClicked: page.term(page.sec.clam ? page.sec.clam.install : "")
        }
        Row3 {
            visible: !!(page.sec.clam && page.sec.clam.installed === true)
            sym: "database"; glyph: ""
            warn: page.sec.clam && (page.sec.clam.db_days === null || page.sec.clam.db_days > 14)
            label: page.sec.clam ? (page.sec.clam.version || "ClamAV") : ""
            desc: page.sec.clam && page.sec.clam.db_days !== null && page.sec.clam.db_days !== undefined ? I18n.t("Virus database") + ": " + page.sec.clam.db_days + " d" : I18n.t("No virus database yet: update it first")
            btn: I18n.t("Update database")
            onClicked: page.term("sudo freshclam")
        }
        Item {
            visible: !!(page.sec.clam && page.sec.clam.installed === true)
            width: parent.width; height: 52
            Row {
                spacing: 10
                anchors.verticalCenter: parent.verticalCenter
                Btn { text: I18n.t("Quick scan"); sym: "bolt"; icon: ""; variant: "filled"; enabled: !page.scanning; opacity: enabled ? 1 : 0.5
                    onClicked: page.sh(["scan", "quick"]) }
                Btn { text: I18n.t("Scan home folder"); sym: "folder"; icon: ""; variant: "tonal"; enabled: !page.scanning; opacity: enabled ? 1 : 0.5
                    onClicked: page.sh(["scan", "home"]) }
            }
        }
        ToggleRow {
            visible: !!(page.sec.clam && page.sec.clam.installed === true)
            label: I18n.t("Scan every week")
            desc: I18n.t("A quick scan in the background (it does not slow you down). You get a notification only if something is found.")
            checked: page.sec.weekly === true
            onToggled: function(v) { const n = Object.assign({}, page.sec); n.weekly = v; page.sec = n; page.sh(["weekly", v ? "on" : "off"]) }
        }
        Rectangle {
            visible: page.scanning
            width: parent.width; height: 76; radius: M3.rM; color: M3.surfaceC
            WavyBar { id: wb; x: 18; y: 16; width: parent.width - 36 - stopBtn.width - 12; height: 10
                SequentialAnimation on value { loops: Animation.Infinite; running: page.scanning
                    NumberAnimation { from: 0.05; to: 0.95; duration: 1800; easing.type: Easing.InOutSine }
                    NumberAnimation { from: 0.95; to: 0.05; duration: 1800; easing.type: Easing.InOutSine } } }
            T { x: 18; y: 38; text: (page.prog.files || 0) + " " + I18n.t("files") + " · " + (page.prog.current || ""); font.pixelSize: 12; color: M3.inkDim
                width: parent.width - 36 - stopBtn.width - 12; elide: Text.ElideMiddle }
            Btn { id: stopBtn; text: I18n.t("Stop"); variant: "outlined"; anchors.right: parent.right; anchors.rightMargin: 14; anchors.verticalCenter: parent.verticalCenter
                onClicked: page.sh(["stop"]) }
        }
        Repeater {
            model: page.scanning ? [] : page.found
            delegate: Row3 {
                required property var modelData
                warn: true; sym: "bug_report"; glyph: ""
                label: modelData.name
                desc: modelData.path
            }
        }
        Row3 {
            visible: !page.scanning && page.found.length > 0
            warn: true; sym: "gpp_maybe"; glyph: ""
            label: I18n.t("Move them to quarantine")
            desc: I18n.t("They are locked in a folder where nothing can open them. You can restore or delete them.")
            btn: I18n.t("Quarantine"); btnVariant: "filled"
            onClicked: page.sh(["quarantine"])
        }
        Row3 {
            visible: !page.scanning && !!(page.sec.last && page.sec.last.when) && page.found.length === 0 && !!(page.sec.progress && page.sec.progress.done === true)
            sym: "verified_user"; glyph: ""
            label: I18n.t("No threats found")
            desc: (page.prog.files || 0) + " " + I18n.t("files") + " · " + page.ago(page.prog.end)
        }
        T { visible: !!page.prog.error; text: page.prog.error || ""; color: M3.error; width: parent.width; wrapMode: Text.WordWrap }

        // quarantine
        SectionTitle { visible: (page.sec.quarantine || []).length > 0; text: I18n.t("Quarantine"); sub: I18n.t("Files that were moved here are locked.") }
        Repeater {
            model: page.sec.quarantine || []
            delegate: Row3 {
                required property var modelData
                sym: "lock"; glyph: ""
                label: modelData.virus
                desc: modelData.from
                btn: I18n.t("Delete"); btnVariant: "danger"
                onClicked: page.sh(["delete", modelData.name])
                Btn { text: I18n.t("Restore"); variant: "text"; anchors.right: parent.right; anchors.rightMargin: 14 + 120 + 8; anchors.verticalCenter: parent.verticalCenter; height: 36
                    onClicked: page.sh(["restore", modelData.name]) }
            }
        }

        // ---------- the system ----------
        SectionTitle { text: I18n.t("Check your system"); sub: I18n.t("A quick look at the things that matter. Nothing is changed here.") }
        Repeater {
            model: page.sec.checks || []
            delegate: Row3 {
                required property var modelData
                warn: !modelData.ok
                sym: modelData.ok ? "check_circle" : "warning"; glyph: modelData.ok ? "" : ""
                label: I18n.t(modelData.name)
                desc: modelData.text
                btn: modelData.fix && modelData.fix.indexOf("sudo") === 0 && !modelData.ok ? I18n.t("Fix") : ""
                onClicked: page.term(modelData.fix.split("   (")[0])
            }
        }

        // ---------- the shell's own files ----------
        SectionTitle { text: I18n.t("Shell files"); sub: I18n.t("Notices when the shell's scripts and Quickshell files are changed by something else than an update.") }
        Row3 {
            warn: page.changed > 0
            sym: page.changed > 0 ? "warning" : (page.integ.baseline ? "task_alt" : "help"); glyph: page.integ.baseline ? "" : ""
            label: !page.integ.baseline ? I18n.t("Not watching yet") : (page.changed > 0 ? page.changed + " " + I18n.t("file(s) changed or added") : I18n.t("All shell files are as they were"))
            desc: page.integ.baseline ? (page.integ.files + " " + I18n.t("files") + " · " + page.ago(page.integ.when)) : I18n.t("Trust the files as they are now, and they are watched from here.")
            btn: page.integ.baseline ? I18n.t("Trust current files") : I18n.t("Start watching"); btnVariant: page.changed > 0 ? "tonal" : "filled"
            onClicked: page.sh(["baseline"])
        }
        Repeater {
            model: (page.integ.changed || []).concat(page.integ.new || [])
            delegate: Row3 {
                required property var modelData
                warn: true; sym: "edit_document"; glyph: ""
                label: modelData
                desc: (page.integ.changed || []).indexOf(modelData) >= 0 ? I18n.t("Changed") : I18n.t("New file")
            }
        }

        // ---------- experimental ----------
        Item { width: 1; height: 10 }
        SettingRow {
            label: I18n.t("Experimental")
            desc: I18n.t("A switch that changes how the system behaves. Read before you use it.")
            reserved: 150
            Btn { anchors.right: parent.right; anchors.rightMargin: 12; anchors.verticalCenter: parent.verticalCenter
                text: page.experimental ? I18n.t("Hide") : I18n.t("Show"); variant: "tonal"; onClicked: page.experimental = !page.experimental }
        }
        Column {
            visible: page.experimental
            width: parent.width
            spacing: 8
            SettingRow {
                visible: !page.niri
                label: I18n.t("Clear Hyprland logs")
                desc: I18n.t("Removes the log files Hyprland has written (they can hold window titles and paths).")
                reserved: 130
                Btn { anchors.right: parent.right; anchors.rightMargin: 12; anchors.verticalCenter: parent.verticalCenter; text: I18n.t("Clear"); variant: "tonal"
                    onClicked: { page.sh(["clear-logs"]); page.ctl.status = "Hyprland logs removed" } }
            }
            ToggleRow {
                label: I18n.t("Harden the system (anti-spy)")
                desc: I18n.t("Programs can't read each other's memory and kernel details are hidden from them. Asks for your password in a terminal. Debuggers that attach to a running program (gdb -p) then need sudo.")
                checked: page.sec.hardening && page.sec.hardening.file === true
                onToggled: function(v) { page.term(v ? page.sec.hardening.on_cmd : page.sec.hardening.off_cmd) }
            }
            Rectangle {
                width: parent.width; height: note.implicitHeight + 24; radius: M3.rM; color: M3.alpha(M3.error, 0.1)
                T { id: note; x: 16; anchors.verticalCenter: parent.verticalCenter; width: parent.width - 32; wrapMode: Text.WordWrap; font.pixelSize: 12; color: M3.inkDim
                    text: I18n.t("Nothing can stop someone who already has root on your computer. These switches make it harder to get there and easier to notice, they do not make you safe from everything.") }
            }
        }
    }
}
