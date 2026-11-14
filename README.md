<p align="center">
  <img src="assets/banner-dark.svg" alt="blvcksyxx shell" width="100%">
</p>

<p align="center">
  <b>A Hyprland and niri desktop with a Quickshell settings app, bar, launcher, desktop widgets and dock.</b><br>
  Everything is set with sliders and switches in one app. No config editing.
</p>

<p align="center">
  <a href="https://shell.blvcksyxx.xyz"><img src="https://img.shields.io/badge/website-shell.blvcksyxx.xyz-8B7BFF?style=for-the-badge&labelColor=11111b&logo=googlechrome&logoColor=white" alt="Website"></a>
  <a href="#supported-systems"><img src="https://img.shields.io/badge/Arch_Linux-1793D1?style=for-the-badge&labelColor=11111b&logo=archlinux&logoColor=1793D1&color=1a1b26" alt="Arch Linux"></a>
  <a href="#supported-systems"><img src="https://img.shields.io/badge/CachyOS-08A283?style=for-the-badge&labelColor=11111b&logo=cachyos&logoColor=08A283&color=1a1b26" alt="CachyOS"></a>
  <a href="#supported-systems"><img src="https://img.shields.io/badge/Fedora-51A2DA?style=for-the-badge&labelColor=11111b&logo=fedora&logoColor=51A2DA&color=1a1b26" alt="Fedora"></a>
  <a href="#supported-systems"><img src="https://img.shields.io/badge/NixOS-5277C3?style=for-the-badge&labelColor=11111b&logo=nixos&logoColor=7EBAE4&color=1a1b26" alt="NixOS"></a>
</p>
<p align="center">
  <img src="https://img.shields.io/badge/Hyprland-0.55%2B-58E1FF?style=for-the-badge&labelColor=11111b&logo=hyprland&logoColor=58E1FF&color=1a1b26" alt="Hyprland 0.55+">
  <img src="https://img.shields.io/badge/niri-25.05%2B-F4A261?style=for-the-badge&labelColor=11111b&logo=wayland&logoColor=F4A261&color=1a1b26" alt="niri 25.05+">
  <img src="https://img.shields.io/badge/Quickshell-QML-8B7BFF?style=for-the-badge&labelColor=11111b&logo=qt&logoColor=8B7BFF&color=1a1b26" alt="Quickshell">
</p>
<p align="center">
  <a href="https://github.com/blvcksyxx/blvcksyxx-shell/releases/tag/v1.1"><img src="https://img.shields.io/badge/release-v1.1-8B7BFF?style=for-the-badge&labelColor=11111b&logo=github&logoColor=white" alt="blvcksyxx shell 1.1"></a>
  <a href="https://github.com/blvcksyxx/blvcksyxx-shell/stargazers"><img src="https://img.shields.io/github/stars/blvcksyxx/blvcksyxx-shell?style=for-the-badge&labelColor=11111b&logo=starship&logoColor=f5c542&color=f5c542" alt="Stars"></a>
  <a href="https://github.com/blvcksyxx/blvcksyxx-shell/commits"><img src="https://img.shields.io/github/last-commit/blvcksyxx/blvcksyxx-shell?style=for-the-badge&labelColor=11111b&logo=git&logoColor=white&color=4c566a&label=updated" alt="Last commit"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-2ea043?style=for-the-badge&labelColor=11111b&logo=opensourceinitiative&logoColor=white" alt="MIT license"></a>
</p>

<p align="center">
  <a href="https://shell.blvcksyxx.xyz"><b>shell.blvcksyxx.xyz</b></a> — features, screenshots and install guides ·
  <a href="#screenshots">Screenshots</a>
</p>
<p align="center">
  <a href="#install-in-one-minute">Install</a> ·
  <a href="#supported-systems">Systems</a> ·
  <a href="#platform-support">Platforms</a> ·
  <a href="#features">Features</a> ·
  <a href="#keybinds">Keybinds</a> ·
  <a href="docs/INSTALL.md">Docs</a> ·
  <a href="docs/CUSTOMIZE.md">Customize</a> ·
  <a href="docs/TESTING.md">Testing</a>
</p>

---

## Screenshots
Screenshots of the running shell. More on the [website](https://shell.blvcksyxx.xyz/#previews).

<p align="center">
  <a href="https://shell.blvcksyxx.xyz/#previews"><img src="assets/screenshots/settings-home.webp" alt="blvcksyxx shell Settings home" width="100%"></a>
</p>
<p align="center">
  <a href="https://shell.blvcksyxx.xyz/#previews"><img src="assets/screenshots/settings-bar.webp" alt="blvcksyxx bar and Dynamic island settings" width="49%"></a>
  <a href="https://shell.blvcksyxx.xyz/#previews"><img src="assets/screenshots/settings-theme.webp" alt="blvcksyxx shell color themes" width="49%"></a>
</p>
<p align="center">
  <a href="https://shell.blvcksyxx.xyz/#previews"><img src="assets/screenshots/settings-widgets.webp" alt="blvcksyxx shell desktop widgets" width="49%"></a>
  <a href="https://shell.blvcksyxx.xyz/#previews"><img src="assets/screenshots/settings-keybinds.webp" alt="blvcksyxx shell keybinds" width="49%"></a>
</p>
<p align="center">
  <a href="https://shell.blvcksyxx.xyz/#previews"><img src="assets/screenshots/settings-notifications.webp" alt="blvcksyxx shell notifications" width="49%"></a>
  <a href="https://shell.blvcksyxx.xyz/#previews"><img src="assets/screenshots/settings-update.webp" alt="blvcksyxx shell Update Center v1.1" width="49%"></a>
</p>

**v1.1 highlights:** Task view and `ALT + Tab`, custom keybinds in Settings, Weather / System / Date bar cards, new desktop widgets and frame rate, whole-look themes with app colors, and a safer Update Center. Full list in the [release notes](docs/releases/v1.1.md).

## Supported systems
The bar, the welcome window and Settings show **your distro's logo** automatically.

| System | Status | How |
| --- | --- | --- |
| **NixOS** | main system | the module in `nix/`, then `./install.sh` |
| **Arch Linux** | supported | `./install.sh` |
| **CachyOS** | supported | `./install.sh` (Arch based: its repositories and `paru` are used) |
| **EndeavourOS, Garuda** | Arch route | `./install.sh` |
| **Fedora, Nobara** | supported | `./install.sh` (COPR for Hyprland and Quickshell) |
| **Bazzite, Silverblue** | commands only | the installer prints the `rpm-ostree` steps |
| **Manjaro** | may not work | its packages are held back, Hyprland can be older than 0.55 |

If something does not install, open an issue with the installer log and it gets fixed fast.

### Hyprland or niri
The shell runs on **Hyprland** and on **niri** (the scrollable-tiling window manager), on every Linux system above. Hyprland is set up by default; `./install.sh --wm=niri` sets up niri, `--wm=both` both (then you pick one on the login screen).

On niri the shell works the same, except Infinite Desktop, which is Hyprland-only: the bar, the island, workspaces, widgets, dock, launcher, lock screen, Settings and its sliders (gaps, borders, corners, shadows, blur, animation styles, keyboard, monitors, your keybinds and autostart). The shell writes `~/.config/niri/config.kdl` for you (`rice-niri`) and checks it with `niri validate`, so it fits your niri version; your own niri settings go in `~/.config/niri/user.kdl` and always win. Blur needs niri 26.04 or newer. niri extras: `SUPER + Tab` opens the Task view, `ALT + Tab` the window switcher, `SUPER + O` niri's overview, and `SUPER + Shift + /` lists every key. Windows sit in columns (`SUPER + R` changes the width, `SUPER + F` maximizes, `SUPER + [` / `]` takes a window in or out of a column).

## Platform support
blvcksyxx shell is a **Linux desktop shell**. It is a set of Hyprland/niri configuration, helper scripts and Quickshell QML; it is not a standalone cross-platform application.

| Platform | Status | Notes |
| --- | --- | --- |
| **Linux, Wayland, Hyprland 0.55+** | supported | full feature set; the installer checks the Hyprland version |
| **Linux, Wayland, niri 25.05+** | supported | full feature set except Infinite Desktop (Hyprland-only); blur needs niri 26.04+ |
| **macOS (Intel or Apple Silicon)** | **not supported** | Quickshell, Hyprland and niri are Wayland/Linux projects. There is no native macOS build of this shell; the installer stops on Darwin with an explanation instead of making a broken partial install. A macOS version would have to be a separate native application, not this codebase. |

**Component compatibility**

| Component | Minimum | Checked by |
| --- | --- | --- |
| Hyprland | 0.55 | `install.sh` (`HYPR_MIN_MAJOR` / `HYPR_MIN_MINOR`) and `hypr_too_old` |
| niri | 25.05 (26.04 for blur) | `bin/rice-niri` feature detection and `niri validate` |
| Quickshell | the version packaged by your distro / COPR / nixpkgs | `install.sh` package step; QML syntax is checked with `qmllint` (`docs/TESTING.md`) |
| Python | 3.10+ | helper scripts use modern `python3` syntax |

## Install in one minute
Pick your system, paste the three lines, then log out, choose **Hyprland** or **niri** on the login screen and press `SUPER + U`.

**Arch Linux / CachyOS / EndeavourOS / Garuda**
```bash
sudo pacman -S --needed git base-devel
git clone https://github.com/blvcksyxx/blvcksyxx-shell && cd blvcksyxx-shell
./install.sh
```

**Fedora / Nobara**
```bash
sudo dnf install -y git
git clone https://github.com/blvcksyxx/blvcksyxx-shell && cd blvcksyxx-shell
./install.sh
```

**NixOS**
```bash
git clone https://github.com/blvcksyxx/blvcksyxx-shell && cd blvcksyxx-shell
# add to /etc/nixos/configuration.nix:
#   imports = [ /path/to/blvcksyxx-shell/nix/module.nix ];
#   programs.blvcksyxx-shell.user = "yourname";    # Infinite Desktop: SUPER + ALT + mouse (input group)
sudo nixos-rebuild switch && ./install.sh
```

The installer asks which window manager you want (Hyprland, niri or both), installs the packages, copies the configs and sets everything up. Every file it replaces is saved in `~/.config/blvcksyxx-shell-backup-<time>/`.
- **Arch:** no AUR helper needed. `paru` or `yay` are used when you have one; otherwise yay is set up only if your Arch lacks something the shell needs. The Bibata cursor comes from GitHub when there is no AUR helper.
- **Fedora:** COPR repositories give the newest Hyprland, Quickshell and awww; Atomic Fedora (Bazzite, Silverblue) gets the `rpm-ostree` commands instead.
- **NixOS:** the module turns on Hyprland and niri (`programs.niri.enable = false;` leaves niri out).

| Option | What it does |
| --- | --- |
| `--wm=hyprland` / `--wm=niri` / `--wm=both` | the window manager, without the question |
| `--yes` | everything, no questions |
| `--aur` / `--no-aur` | Arch: always get yay and every AUR package / never build yay |
| `--no-packages` | skip the package step |
| `--dry-run` | show what would happen, change nothing |
| `--restore` | put back the files from the last backup |

**Updating:** Settings > **Update Center** > Update now (the steps show live, no terminal), the update notification, or `rice-update` in a terminal. Updates are checked against the project's signing key before they run; see [SECURITY.md](SECURITY.md).

## Features
**Settings app** (`SUPER+U`) in the spirit of Material 3: a navigation rail (Home, Wallpaper, Appearance, Motion, Desktop, Bar & launcher, Sound & language, System, Gaming, Security, About, Update Center) with tabs, Google icons, colors made from your theme and a search over every setting.

**Font**: the whole interface uses **Google Sans Flex** (and Google Sans Code for codes), both open source under the SIL Open Font License; the terminal keeps JetBrainsMono Nerd Font.

| Area | What you get |
| --- | --- |
| **blvcksyxx bar** | the Quickshell bar: style Dynamic (the default: an island in the middle that is your clock and grows into the player, volume, workspaces, notifications, today and recording), Flat, Island, Islands, Pills or Notch, auto-hide, a soft shadow, position top, bottom, left or right (a standing bar), size, transparency, workspaces as dots, Pac-Man or letters, clock with seconds, a switch back to Waybar |
| **Bar cards** | Weather, System and Date bar modules; each grows out of its pill into a Material 3 card with the forecast, CPU/RAM/disk/swap or your month, week, tasks and uptime; on a side bar the cards open beside it; Esc or a click outside closes them, and one card closes when another opens |
| **Task view & switcher** | `SUPER + Tab`: every workspace as a live screen with its windows; type to find a window, arrows pick a workspace, click or drag a window, middle click or the x closes it, Esc leaves. `ALT + Tab`: windows in the order you used them; hold ALT, Tab goes on, Shift + Tab back. On niri too; niri's own switcher is turned off and its overview moves to `SUPER + O` |
| **Your keybinds** | Settings > Keybinds keeps the shell's keys and your own keybinds (any app or command on keys you pick) on one page; Task view and the switcher can get other keys there with the pencil |
| **Autohide** | the bar slides in when the pointer touches the screen edge |
| **Distro logo** | the logo of your distro (NixOS, Arch, CachyOS, Fedora, Nobara, EndeavourOS ...) in the bar, the welcome window and Settings, picked automatically |
| **Desktop widgets** | frosted glass over your blurred wallpaper, auto-hide while windows are open; clock, calendar, weather, forecast, music, music card, resources (CPU, RAM, GPU), user card, battery gauges in soft shapes (CPU, RAM, GPU, heat, battery), the date in a flower, a see-through audio visualizer (Bars like cava in a terminal, Mirror, Wave, Dots, in your Theme color, a gradient or rainbow), a to-do list, a focus timer and a note; one Material You card style; colors that turn light or dark with your wallpaper; Sky, Now playing, Player, Play button, Lyrics, Storage and CPU · GPU · RAM; Edit mode with a side panel for widgets, quick settings, the bar and the visualizer |
| **Frame rate** | Settings > Desktop > Frame rate for the moving parts of the widgets (turning shapes, the visualizer): 30, 60 (default), 120 or Screen |
| **Today & System** | click the clock (or `SUPER + ALT + D`) and a Material 3 card grows out of the bar with today (calendar, weather, the day as a wave) and System (CPU, GPU and RAM in wavy rings, the disk); right-click for System. Settings > Dynamic island: weather and date beside the time, what it grows into (music, volume, workspaces, notifications, the charger), which tab a click opens and how fast the card closes |
| **Wallpaper picker** | `SUPER + W`: your wallpapers in a sheet with search, shuffle and keys; colors follow (a black, white or grey wallpaper gives grey colors) |
| **Wallpapers** | animations when one comes in (Ripple from your pointer, Wave, Wipe, Portal, Fade, Slide, Dissolve), a slideshow, **live wallpapers** (videos, with mpvpaper), your Waypaper folders, space wallpapers in the Material style |
| **Desktop menu** | right-click the desktop: your wallpapers in a row, quick switches (next wallpaper, night light, Do Not Disturb, gaming mode, lock) and the places you change most in Settings, in Material 3 with frosted glass |
| **Themes** | a whole look in one click (blvcksyxx, Terminal, Glass, Neon, Ember, Frost), and your colors in VSCodium / VS Code and Discord (Vesktop, Vencord, Equicord, BetterDiscord) |
| **Monitors** | resolution, refresh rate, scale, rotation, arrangement and turning a screen off, on Hyprland and niri |
| **Bar layout** | five ready-made Material 3 layouts, and drag and drop the modules between left, center and right: launcher, workspaces, window title, music, the island (your clock), tray (right-click an app: its menu and Close app; long menus scroll), volume, Bluetooth, Wi-Fi, battery, notifications, power, a music visualizer; the window title with its app icon on the left or right |
| **Dock** | bottom, left or right edge, its own app menu with search, pinned favourite apps (also in Settings > Dock), open apps, hover to reveal, media player, tinted icons; windows keep away from it while it stays out |
| **Hyprland & niri** | gaps, borders, rounding, blur, shadows and animations from sliders, no config editing, on either window manager |
| **Theme** | 21 color schemes: Auto and Grey from your wallpaper, six monochrome (Mono, Slate, Stone, Steel, Ash, Ink) and thirteen colors (Navy, Ocean, Sky, Teal, Mint, Forest, Lime, Gold, Sunset, Ember, Rose, Orchid, Violet). They recolor Waybar, borders, notifications and the lock screen |
| **Control center** | `SUPER + N` or the bell: switches, sliders, music with a wavy, seekable progress line and your notifications, with smooth Material 3 motion |
| **Notifications** | shown by the shell in the Google style (or swaync, one click away): pop-ups with the app icon in your shape, pictures, action buttons and a line that shows how long they stay; position, width, time on screen, six themes, text size, corners, transparency and blur, live preview and a test button |
| **Sfx & sounds** | interface sounds in the shell's own parts (clicks, switches, sliders, typing), eight packs (Pebble, Tap, Soft, Pluck, Keys, Crystal, Bubble, Retro), volume, each sound on or off, quiet music for the welcome; ten notification sounds (Glass, Droplet, Chime, Bubble, Marimba, Aurora, Ping, Harp, Keys, Ripple) or Off |
| **Search** | "Search anything!" in Settings finds every setting ("bar position", "blur", "clock font") and jumps to it |
| **Updates** | a notification when a new version is out ("New version ready"), the **Update Center** in Settings (Update now, every step live, no terminal), `rice-update` in a terminal. If `git pull` cannot run, your changes are kept on a branch and in a stash and the update still goes through |
| **Security** | Settings > Security: a virus scan with ClamAV (quick or home folder, quarantine and restore, optional weekly quick scan), a system check (firewall, SSH, open ports, disk encryption, screen lock, reboot after a kernel update, scheduled jobs, autostart) and a watch on the shell's own files; the installer records a baseline after every install and update |
| **Idle & Lockscreen** | lock, screen-off and sleep timers; the shell's own Material 3 lock screen: your wallpaper (or the screen) blurred, the clock big, stacked, minimal or inside your shape, a greeting with your picture in your shape, chips for weather, battery, notifications, CPU and RAM (wavy rings), the music with a wavy line, the password as shapes, power buttons (Shut down in red), a Preview button; hyprlock is the fallback and still one switch away |
| **Launcher** | the built-in blvcksyxx Launcher: 5 themes (Onyx, Graphite, Midnight, Rose, Paper), layouts list / grid / full-width bar / split (wallpaper on the left), position top, center or bottom, width, rows, corner radius, transparency, blur, font size, icons |
| **Cursors** | Bibata, Hyprcursor themes (Rose Pine) and packs you can download in Settings: Catppuccin, Phinger; live preview |
| **Appearance** | Colors (every color role of your theme), Fonts (typography: text size, heavier headings, rounded letters, the Material 3 type scale), Components (switch icons, corner shape, slider thickness, wavy progress) |
| **Motion** | Hyprland animation styles (calm, lively, bouncy, snappy, minimal) and speed, spring and easing graphs, durations, a shape you can throw |
| **Keyboard** | up to four layouts, the one in use, the keys that switch them, search over every layout |
| **Game bar** | `SUPER + G`: CPU and GPU with their heat, RAM, ping, screenshot, record, microphone, power mode, gaming mode, Do Not Disturb, volume and brightness over your game; its transparency and blur in Settings > Gaming |
| **Welcome intro** | once after installing: night falls over the desktop, a few words, the crescent-moon logo draws itself in, "Take a look" opens it up again and Settings starts a short tour (it lights up one part at a time). Play it again with `rice-welcome show`, only the tour: `rice-welcome tour` |
| **Performance & gaming** | one switch turns off all blur and transparency (Hyprland, kitty, bar, launcher, notifications, dock, widgets); Gaming mode with options to keep blur, animations, shadows or gaps, Do Not Disturb (Settings > Services) |
| **Your settings everywhere** | `settings/` holds saved Settings choices (bar, widgets, lock screen, fonts...), `./install.sh` puts them on your other computers (files you changed there are kept) |
| **Languages** | Settings in 20 languages (English, Polish, Portuguese, Spanish, French, German, Italian, Dutch, Russian, Ukrainian, Turkish, Czech, Swedish, Romanian, Hungarian, Japanese, Korean, Chinese, Indonesian, Vietnamese); the desktop in English and Polish |
| **Installer** | interactive (Install, Update, Choose, Restore), backs up everything, supports Arch, CachyOS, Fedora and NixOS, warns when Hyprland is too old, checks the platform before touching anything; a wallpaper is put on right after installing |

## Keybinds
`SUPER` is the main modifier. On niri the same keys work (the shell's own ones are identical), with niri's column keys in place of the Hyprland layout keys; `SUPER + Shift + /` shows them all there.

| Keys | Action |
| --- | --- |
| `SUPER + U` | open **Settings** |
| `SUPER + Return` | terminal |
| `SUPER + Q` | close window |
| `SUPER + E` | file manager |
| `SUPER + R` | app menu |
| `ALT + Space` | app launcher (blvcksyxx Launcher) |
| `SUPER + V` | toggle floating |
| `SUPER + P` | pseudo-tile |
| `SUPER + J` | toggle split direction |
| `SUPER + M` | exit Hyprland |
| `SUPER + ←/→/↑/↓` | move focus |
| `SUPER + 1 … 0` | go to workspace |
| `SUPER + SHIFT + 1 … 0` | move window to workspace |
| `SUPER + S` | show/hide scratchpad |
| `SUPER + SHIFT + S` | move window to scratchpad |
| `SUPER + scroll` | next/previous workspace |
| `SUPER + left mouse` | drag window |
| `SUPER + right mouse` | resize window |
| `SUPER + Tab` | task view (every workspace as a live screen) |
| `ALT + Tab` | window switcher (hold ALT, Tab goes on, Shift + Tab back) |
| `SUPER + O` | niri overview (niri only) |
| `SUPER + ALT + mouse` | Infinite Desktop: move the canvas (Hyprland, needs the input group) |
| `ALT + ]` / `ALT + [` | volume up / down |
| `SUPER + F12` / `F11` / `F10` | volume up / down / mute (with on-screen display) |
| media keys | play/pause, next, previous |
| `Fn` volume / brightness keys, headset `+` `-` | volume, mute, microphone, brightness |
| `Print` / `SHIFT + Print` | screenshot of a region / the whole screen |
| `SUPER + SHIFT + R` | record a region (press again to stop) |
| `SUPER + A` | control center (quick switches) |
| `SUPER + G` | game bar |
| `SUPER + N` | control center (notifications) |
| `SUPER + ALT + W` | edit desktop widgets (add, move, resize, style) |
| `SUPER + ALT + D` | today & system card from the bar's island |
| `SUPER + W` | wallpaper picker |

## Layout
| Path | Contents |
| --- | --- |
| `bin/` | helper scripts installed to `~/.local/bin` |
| `quickshell/` | Settings app (`rice-settings`) and widgets/dock (`rice-desktop`) |
| `config/` | dotfiles installed to `~/.config` (Hyprland, Waybar, ...); the niri config is written by `bin/rice-niri` |
| `install/` | installer UI and distro detection |
| `lua/` | Hyprland add-ons: keybinds, widgets autostart |
| `wallpapers/` | included wallpapers, made by `install/tools/make-wallpapers.py` (MIT), copied to `~/Pictures/Wallpapers` |
| `sounds/` | notification sounds (made by `install/tools/make-sounds.py`, CC0) |
| `VERSION` | the current version, used by the update check |
| `nix/`, `flake.nix` | NixOS module |
| `.github/` | CI (shellcheck, dry-run install) and issue template |

The lock screen uses the desktop shell's components (`Fonts`, `T`, `Look`, `Blob`, ...):
`rice-lock` copies them into `rice-lockscreen` when the screen locks. `rice-settings` and
`rice-welcome` keep their own small copies of the few components they use, so each app stays
a standalone Quickshell config.

## Development
`settings/` holds the Settings choices saved in this copy (bar, widgets, lock screen, fonts, cursor and the rest). `./install.sh` applies them on other computers, keeps the files you changed there, and `./install.sh --update --use-saved-settings` takes the saved ones anyway.

To release a new version, put the new number in `VERSION` (for example `1.2`) and push. Everyone gets the update notification within a few hours.

## Versioning

blvcksyxx shell follows a `1.x` release series; `VERSION` is the source of truth. The
changelog lists every release.

## License

MIT, see [`LICENSE`](LICENSE).
