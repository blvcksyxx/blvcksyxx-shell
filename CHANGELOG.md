# Changelog

All notable changes to blvcksyxx shell are listed here. The current version is in
`VERSION`.

## V2.0.1

- Update Center and `rice-update check` read the version correctly now: 2.0.0 is shown
  as V2.0.0 instead of V2.01, and patch releases (2.0.1, 2.0.2 ...) are seen as newer
- Every part of a version is compared as a number: `2.0.0` equals `2.0`, `2.0.1` is
  older than `2.1`, and `2.10` is newer than `2.1`; a pre-release suffix is ignored
- A computer without a `VERSION` file is treated as older than every release instead of a
  made-up 2.01, so it is offered the update
- Nothing else changes: settings, themes, wallpapers, the bar and your edits stay

## V2.0.0

- The whole upstream DarkShadowShell V4.77–V4.83 update is in: the Edge bar, the Toolbox,
  screenshot text / translation / colour picking, the record menu, the key sheet, your own
  themes, files in the launcher and live wallpapers on the login screen. The blvcksyxx
  branding, the bottom-right control-centre corner and the fast launcher stay
- Edge bar: a new bar style in Settings > Bar, the default for new installs. Every part is
  one piece with the screen edge, with its own Transparency and blur; "Frame along the edge"
  keeps only the pills. The parts follow the zones and the island in the same frame
- Toolbox on `SUPER + X`: tasks, a note, a focus timer, a converter (units and money), the
  system (processor, graphics, memory, disk, network, temperatures) and a local AI chat.
  It opens like the control centre, has its own Settings page, transparency, blur and an
  optional island, and remembers the tab you used last
- Screenshots: read the text in a region (tesseract), translate it (translate-shell, else
  Google's endpoint only when you press Translate), search with the picture, or pick the
  colour of a pixel. The result card keeps the text or colour on the clipboard
- Record menu on `SUPER + SHIFT + R`: region, window or screen, computer sound and
  microphone (both on by default), with a fallback that records without sound;
  `wf-recorder` and `ffmpeg` come from the installer
- Key sheet on `SUPER + /`: every shell key in groups, with the keys you changed in
  Settings > Keybinds
- Your own themes: Settings > Appearance > Themes saves the current colours, wallpaper,
  corners, shapes, bar, widgets, notifications, windows, motion and font under a name;
  they live in `~/.config/rice/themes` (`presets.json`), survive updates and are included
  in backups. Export and import are plain JSON
- Launcher: files and folders in your home appear after three letters (`/` in front shows
  only files), using `fd`, else `locate`, else a short walk; `.cache` and `node_modules`
  are left out. The new Wallpaper look tints the launcher with your wallpaper's colours
  and is the default for new installs
- Live wallpapers on the SDDM login screen: the video plays there when SDDM's Qt has
  QtMultimedia, and one frame of that video is the picture; without it the picture stays
- Settings: new Toolbox page, Edge bar controls, frame along the edge, and the custom-theme
  controls; the bar and launcher previews follow the new defaults
- AI chat is local-only: Ollama at `http://localhost:11434` by default, no cloud or
  OpenAI-compatible provider, no keys in the UI; `~/.config/rice/ai.json` stays mode 0600
- Installer: `tesseract` with English and Russian language packs,
  `translate-shell`, `fd` and `plocate` are added for the new tools on Arch and Fedora;
  `wf-recorder` and `ffmpeg` were already there, and NixOS gets the same packages
- Russian and English are complete for the new screens; other languages fall back to
  English instead of showing empty labels
- Nothing is reset: settings, wallpapers and your own edits stay; the old Onyx launcher
  default becomes the Wallpaper look once, unless you chose Onyx yourself

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
