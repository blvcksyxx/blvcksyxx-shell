import Quickshell
import QtQuick

// Markdown in the shell's colors: headings, bold and italic, lists, quotes, code and links. Qt reads the
// Markdown; this only sets the look and opens a link in the browser. Used by Toolbox > Note > Preview.
TextEdit {
    id: md
    property var pal
    property string source: ""
    readOnly: true
    selectByMouse: true
    textFormat: TextEdit.MarkdownText
    text: source
    wrapMode: TextEdit.Wrap
    color: pal ? pal.fg : "#F6F5F4"
    selectionColor: pal ? pal.primary : "#9ec9bd"
    selectedTextColor: pal ? pal.inkPrimary : "#0d0d0d"
    font.family: Fonts.main
    font.pixelSize: 14
    onLinkActivated: function(link) { Quickshell.execDetached(["xdg-open", link]) }
}
