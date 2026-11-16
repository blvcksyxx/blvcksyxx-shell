#!/usr/bin/env python3
"""migrate_qml.py DIR desktop|lockscreen: make QML files kept from an older shell work with this one.

The installer keeps a .qml file you changed and puts the new one next to it (FILE.rice-update). A kept file can use
an API that changed in this version; the shell then does not start at all. Two such changes are fixed here:

  SoftShadow -> Shadow          the two shadow types became one (Shadow.qml)
  Player { id: x; running: e }  Player became a singleton: it cannot be created; the new files hold() / release() it
  Player { ... } in the lock screen -> LockPlayer (its own player, still creatable)

Only the exact old patterns are rewritten, the rest of your file stays as it is. A backup (FILE.before-v1.11.1) is
kept. Changed paths are printed, one per line, so the installer can record their new SHA-256.
"""
import os
import re
import shutil
import stat
import sys
import tempfile

BACKUP = ".before-v1.11.1"
PLAYER = re.compile(
    r"(?m)^([ \t]*)Player[ \t]*\{[ \t]*id:[ \t]*([A-Za-z_][A-Za-z0-9_]*)[ \t]*;[ \t]*"
    r"running:[ \t]*([^\n}]*?)[ \t]*\}[ \t]*$"
)


def has_shadow(path):
    """the new shell renamed SoftShadow.qml to Shadow.qml (it is shared with the lock screen)"""
    d = os.path.dirname(path)
    return os.path.exists(os.path.join(d, "Shadow.qml")) or os.path.exists(
        os.path.join(d, "..", "rice-desktop", "Shadow.qml"))


def write(path, text):
    fd, tmp = tempfile.mkstemp(prefix=".rice-qml-", dir=os.path.dirname(path), text=True)
    try:
        with os.fdopen(fd, "w", encoding="utf-8") as f:
            f.write(text)
        os.chmod(tmp, stat.S_IMODE(os.stat(path).st_mode))
        os.replace(tmp, path)
    except Exception:
        try:
            os.unlink(tmp)
        except OSError:
            pass
        raise


def backup(path):
    b = path + BACKUP
    if not os.path.exists(b):
        try:
            shutil.copy2(path, b)
        except OSError:
            pass


def migrate(path, kind):
    try:
        with open(path, encoding="utf-8") as f:
            old = f.read()
    except (OSError, UnicodeDecodeError):
        return False
    text = old
    if has_shadow(path):
        text = re.sub(r"\bSoftShadow\b", "Shadow", text)
    if kind == "lockscreen":
        # the lock screen has its own creatable player; an old file still says Player
        if os.path.exists(os.path.join(os.path.dirname(path), "LockPlayer.qml")):
            text = re.sub(r"\bPlayer\b(?=\s*\{)", "LockPlayer", text)
    else:
        ids = []

        def repl(m):
            ids.append(m.group(2))
            return ("%sInstantiator { model: (%s) ? 1 : 0; delegate: QtObject { "
                    "Component.onCompleted: Player.hold(); Component.onDestruction: Player.release() } }"
                    % (m.group(1), m.group(3).strip()))

        text = PLAYER.sub(repl, text)
        for ident in sorted(set(ids)):
            text = re.sub(r"\b%s\." % re.escape(ident), "Player.", text)
    if text == old:
        return False
    backup(path)
    write(path, text)
    return True


def main():
    if len(sys.argv) < 2:
        print(__doc__.strip().splitlines()[0], file=sys.stderr)
        return 2
    root = os.path.abspath(sys.argv[1])
    kind = sys.argv[2] if len(sys.argv) > 2 else "desktop"
    if not os.path.isdir(root):
        return 0
    for name in sorted(os.listdir(root)):
        if not name.endswith(".qml"):
            continue
        if any(x in name for x in (".rice-update", ".before-", ".stale-", ".backup-")):
            continue
        path = os.path.join(root, name)
        if migrate(path, kind):
            print(path)
    return 0


if __name__ == "__main__":
    sys.exit(main())
