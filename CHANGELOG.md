# Changelog

All notable changes to blvcksyxx shell are listed here. The current version is in
`VERSION`.

## V1.11.1

- Fixed an update from V1.1 that could stop the desktop from loading: the installer no longer
  treats a QML file that only differs by the `SoftShadow` → `Shadow` rename as your edit, so
  the old desktop files are replaced instead of staying next to the new singleton `Player`
- Kept QML files are migrated to this version's API (`SoftShadow` → `Shadow`, desktop
  `Player { ... }` → the singleton's `hold()` / `release()`, lock screen `Player` →
  `LockPlayer`) with a `.before-v1.11.1` backup; only the exact old patterns change
- The desktop now logs to `~/.cache/rice/desktop.log`; if Quickshell quits while loading, it
  takes the `.rice-update` files, migrates kept ones, retries once and says where the log is
- The lock screen restores its own missing QML files from the repository and migrates kept
  ones before it starts, so a broken update no longer leaves it without `shell.qml` or with
  an old `Player`
- Nothing is reset: settings, wallpapers and your own edits stay

## V1.11

- New screenshot tool on Print and `SUPER + SHIFT + S`: the screen freezes and a Material 3
  toolbar at the bottom offers Region (drag, move, resize, real pixel size and a loupe),
  Window (outlined, with the app name) and Screen; save to `Pictures/Screenshots` and copy,
  copy only, open in satty or swappy, `Esc` cancels
- Infinite Desktop: the wallpaper travels with the canvas (zoom from 1.05x to 1.5x) and the
  bar and dock step aside while you move; live while `SUPER + ALT` and the mouse, smooth with
  the keys, the wheel and `SUPER + CTRL` + arrows; fixes for NVIDIA, app pop-ups such as
  Steam toasts, a second daemon, and the input group working without a logout
- New Material 3 lock screen (Cards or Classic) with a real preview in Settings, a 30-second
  test, clock fonts that install themselves, the music card, keyboard layout and power
  buttons; hyprlock stays only as a fallback
- Clipboard history on `SUPER + V`: texts and pictures, search, pinning, paste at once,
  settings for how much to keep; `cliphist` and `wtype` come from the installer
- New wallpaper picker carousel on `SUPER + W`: the wallpaper in focus is big and sharp, the
  next ones get narrower, with search, All / Pictures / Live and shuffle; switches for
  wallpapers from the shell and for the picker, plus slideshow and live wallpaper options
- Window rules in Settings: your own rules for any app (workspace, floating, size, every
  workspace, fullscreen, maximized, see-through) and a gaming workspace for Steam, Proton,
  Wine, gamescope and Minecraft; your own Hyprland settings live in `~/.config/hypr/user.lua`,
  which no update touches
- The shell's own SDDM login screen: your wallpaper and colors, a big clock, blur and a
  rising login card with your picture, session, keyboard layout and power buttons; Settings
  can install or update it, make SDDM start at boot, or go back to SDDM's theme. The picture
  you choose now shows on the login screen too
- File manager picker in Settings > Desktop > Look & Feel (Files, Thunar, Nemo, Dolphin,
  PCManFM), opened with `SUPER + E` and for every "open folder"; wallpaper colors in GTK and
  KDE apps and a Material 3 files look, each with a switch
- Performance: the bar's shadow no longer costs frames, Settings can wait ready in the
  background or start on demand, menus and panels are made only when opened, and the CPU,
  RAM and disk rings glide instead of blinking
- The whole shell is translated into the 20 languages of Settings > System > Languages (bar,
  cards, control center, menus, notifications, launcher, clipboard, wallpaper picker,
  widgets, lock screen); Japanese, Korean and Chinese fonts are downloaded on demand, with
  pinned URLs and SHA-256
- Security and privacy: every third-party download is pinned and checked with SHA-256 before
  unpacking, archives cannot write outside their folder, updates come only from this project,
  a changed installer asks first, the `input` group is opt-in, weather needs a place set and
  uses HTTPS, lyrics are opt-in, and update checks run once a day
- Artix Linux support (OpenRC, runit, s6 or dinit) with Arch's repositories, services through
  your init and a D-Bus login session; Flatpak works without systemd; Fedora and Nobara
  install through COPR
- Bar on every screen, the date in the Dynamic island, one workspace color from the wallpaper,
  a transparent btop theme, a music card on the bar, dock icons in the wallpaper's colors,
  smoother Task view, a Wi-Fi menu that stays usable, better Bluetooth headphones, Flatpak
  apps in the launcher, foot 1.26+, exact refresh rates on niri and real blur on niri
- Installer: long steps show their output as they run, `--no-upgrade` skips the system
  update, updates keep your edits, ZIP copies turn into git copies, update terminals no
  longer pile up, the keyboard layout survives updates, and a left-over pacman lock is
  reported before anything starts
- Docs, tests and CI: `SECURITY.md`, `tests/security.sh` in CI, ShellCheck, Python
  compilation, Qt 6 `qmllint`, a pinned-download guard and a signed-commit check
- Kept from the shell's own fixes: the bottom-right screen corner opens the control center,
  and the launcher answers at once without a double toggle

## V1.1

- New Task view (`SUPER + Tab`) and window switcher (`ALT + Tab`) on Hyprland and niri;
  niri's overview moves to `SUPER + O` and its own switcher is off
- Settings > Keybinds keeps the shell's keys and your own keybinds on one page, including
  keys for the Task view and the switcher
- New bar modules Weather, System and Date, each growing out of its pill into a Material 3
  card; the bar can stand on the left or right edge, and the cards open beside it
- New widgets Forecast, Music card and Date & time (the System widget moved into the bar as
  a card); one Material You widget style; frame rate for moving parts (30, 60, 120 or
  Screen); widgets auto-hide while windows are open
- Wallpaper animations, slideshow, live wallpapers, space wallpapers and the Material 3
  desktop menu
- Whole-look themes (blvcksyxx, Terminal, Glass, Neon, Ember, Frost) and your colors in
  VSCodium / VS Code and Discord
- Smoother side bars, menus that blur as they arrive, one shared cava, a lighter visualizer,
  a charger animation, better niri blur and live wallpapers, and an Update Center that keeps
  local changes aside when `git pull` cannot run
- Settings > Security: virus scan, system check, shell-file watch and the installer baseline
  step
- The installer checks the platform before touching anything: Linux with Hyprland 0.55+ or
  niri 25.05+ is supported; macOS is not
- Installer and updater fixes, documentation, website and release assets

## V1

- First release of **blvcksyxx shell**, with the Material 3 Settings app, bar and
  dynamic island, launcher, desktop widgets, dock, lock screen and security tools
- Hyprland and niri support, installers for Arch-based distros, Fedora, Nobara and NixOS,
  backups and a one-command restore
- Infinite Desktop, keybind editor, gaming mode, performance switches, screen recording,
  screenshots, media and lyrics, weather, updates and a welcome window
