# Testing

Test the installer and the shell without touching your live setup. Run every command from
the repository root.

## 1. Static checks

```bash
# shell syntax
bash -n install.sh install/lib/*.sh
for f in bin/*; do head -n1 "$f" 2>/dev/null | grep -q bash && bash -n "$f"; done

# platform gate: on Linux it proceeds, on anything else it exits before changing files
./install.sh --dry-run --yes

# python syntax
python3 -m py_compile install/lib/fixup.py install/tools/*.py

# QML syntax (Quickshell warnings are normal; look for "Syntax error")
err="$(mktemp)"
while IFS= read -r -d '' f; do
  qmllint "$f" >/dev/null 2>"$err" || {
    grep -qi 'syntax error' "$err" && { echo "FAIL $f"; cat "$err"; }
  }
done < <(find quickshell -name '*.qml' -print0)
rm -f "$err"
```

License check: `LICENSE` must contain the MIT permission notice and the copyright lines.

```bash
test -s LICENSE
grep -q 'MIT License' LICENSE
grep -q 'Permission is hereby granted' LICENSE
```

Privacy check: no home paths, user names, private keys, tokens or personal e-mail addresses.

```bash
grep -rIn '/home/blvcksyxx' . --exclude-dir=.git --exclude=TESTING.md
grep -rInE 'BEGIN (RSA|OPENSSH|EC|DSA) PRIVATE KEY|ghp_[A-Za-z0-9]{20,}|github_pat_|AKIA[0-9A-Z]{16}' . \
  --exclude-dir=.git --exclude=TESTING.md
grep -rInE '[[:alnum:]._%+-]+@[[:alnum:].-]+\.[A-Za-z]{2,}' . \
  --exclude-dir=.git --exclude=TESTING.md \
  | grep -vE 'users\.noreply\.github\.com|@HOME@|@USER@|example\.(com|org)' || true
```

File inventory: wallpapers, sounds, scripts and settings must be present and executable.

```bash
find wallpapers -type f | sort
find sounds -type f | wc -l
find bin -type f ! -perm -u+x
jq empty settings/rice/*.json
```

## 2. Dry run in a temporary HOME

The dry run changes nothing and is safe even inside a running Hyprland session.

```bash
tmp="$(mktemp -d)"
HOME="$tmp" ./install.sh --yes --dry-run --no-packages
find "$tmp" -mindepth 1 -print
```

Expected: the installer prints the planned steps, finishes without errors, and `find` prints
nothing. Review the step list: package step skipped, window manager question skipped,
backup folder would be `$HOME/.config/blvcksyxx-shell-backup-<time>`.

Also test the help and the argument guard:

```bash
./install.sh --help
./install.sh --definitely-not-an-option; echo "exit=$?"   # non-zero, usage shown
```

## 3. Full install in a VM or a separate user

A real install writes configs and may restart the running shell, so do it in a VM or as a
user who is not running the shell.

### Virtual machine (recommended)

1. Start an Arch, CachyOS or Fedora VM and take a snapshot.
2. Clone the repository inside the VM and run the interactive installer:

   ```bash
   git clone https://github.com/blvcksyxx/blvcksyxx-shell && cd blvcksyxx-shell
   ./install.sh
   ```

3. Reboot, pick **Hyprland** (or **niri**) on the login screen.
4. Run the smoke test below.
5. Restore the snapshot for the next test.

### Separate user on the current machine

Packages are skipped if the host already has them; add `--no-packages` to be safe.

```bash
sudo useradd -m -s /bin/bash rice-test
sudo passwd rice-test
sudo -u rice-test git clone https://github.com/blvcksyxx/blvcksyxx-shell /home/rice-test/blvcksyxx-shell
sudo -u rice-test /home/rice-test/blvcksyxx-shell/install.sh --yes --no-packages
```

Log out, log in as `rice-test`, choose Hyprland, and run the smoke test. Remove the user
afterwards with `sudo userdel -r rice-test`.

## 4. Install on your own machine

Do this only after the repository is committed, so the old state can be recovered.

1. Back up the current setup separately if it matters:

   ```bash
   rsync -a ~/.config/ ~/.config-before-blvcksyxx-install/
   ```

2. Dry run first:

   ```bash
   ./install.sh --dry-run
   ```

3. Real install:

   ```bash
   ./install.sh
   ```

4. The installer saves every replaced file in `~/.config/blvcksyxx-shell-backup-<time>/`.
   Undo with:

   ```bash
   ./install.sh --restore
   ```

## 5. Smoke test after install

- Log out and back in, choose the window manager, and confirm the desktop starts.
- `SUPER + U` opens Settings; **About** shows the expected version and **Home** shows the
  distribution logo.
- The bar appears, the launcher (`SUPER + R`), wallpaper picker (`SUPER + W`), control
  center (`SUPER + N`) and game bar (`SUPER + G`) open.
- `SUPER + ALT + W` opens widget edit mode; **Onyx**, **Google** and **Outline** styles
  can be selected.
- The bottom-right hot corner opens the control center.
- The lock screen preview works in Settings > Idle; locking and unlocking works.
- The saved choices arrived: Russian locale (`settings/rice/region.json`), Navy color
  mode, custom control center layout, custom bar and widget setup.
- No sound-hardware helper is installed and no PulseAudio configuration is copied.

Commands:

```bash
hyprctl configerrors          # Hyprland: empty output
niri validate                 # niri: no errors
pgrep -af 'quickshell|qs'     # shell processes are running
rice-update                   # after the GitHub repository exists
```

## 6. Update and restore

```bash
./install.sh --update --dry-run
./install.sh --update
./install.sh --restore          # interactive, picks the newest backup
```

Check that `--update` keeps local changes to config files and that `--restore` puts the
backup back without deleting files that did not exist before the install.

## 7. Clean clone check

```bash
tmp="$(mktemp -d)"
git clone /path/to/blvcksyxx-shell "$tmp/blvcksyxx-clean"
cd "$tmp/blvcksyxx-clean"
bash -n install.sh install/lib/*.sh
for f in bin/*; do head -n1 "$f" 2>/dev/null | grep -q bash && bash -n "$f"; done
git status --short
git log --format='%an <%ae>%n%s'
```

Expected: no submodules, no broken symlinks, no untracked files, and every commit authored
by `blvcksyxx <blvcksyxx@users.noreply.github.com>`.

## 8. Publish

Update `VERSION` and the notes in `docs/releases/`, commit, then tag that commit:

```bash
git tag -a v1.1 -m 'blvcksyxx shell 1.1'
git push origin main v1.1
```

Create the GitHub release from the notes file (`gh release create v1.1 --title 'v1.1'
--notes-file docs/releases/v1.1.md`) or with **Releases → Draft a new release**. Upload
`assets/social-preview.png` as the repository social preview in **Settings → General →
Social preview**. Then test the updater:

```bash
rice-update
```

## Expected warnings

- `qmllint` reports warnings for Quickshell-specific properties; only syntax errors matter.
- `quickshell/rice-lockscreen/` keeps only the lock screen's own QML: the shared components
  (`Fonts`, `T`, `Look`, `Blob`, ...) are copied from `rice-desktop` by `rice-lock` (`sync_shared`)
  when the screen locks, so linting that folder alone may call them unknown.
- `settings/rice/region.json` intentionally keeps `"lang": "ru"`.
