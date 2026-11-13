import Quickshell
import Quickshell.Wayland
import QtQuick

PanelWindow {
    id: edge
    visible: true
    color: "transparent"
    anchors { right: true; bottom: true }
    implicitWidth: 12
    implicitHeight: 12
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "blvcksyxx-cc-corner"
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

    mask: Region { item: hotspot }

    Item {
        id: hotspot
        anchors.fill: parent
        HoverHandler {
            onHoveredChanged: {
                if (hovered) openTimer.restart()
                else openTimer.stop()
            }
        }
    }

    Timer {
        id: openTimer
        interval: 45
        onTriggered: Quickshell.execDetached([
            "bash", "-lc",
            "mkdir -p \"$HOME/.cache/rice\"; printf \"%s\n\" \"corner open $(date +%s%N)\" > \"$HOME/.cache/rice/cc-open\""
        ])
    }
}
