export const site = {
  name: 'blvcksyxx shell',
  shortName: 'blvcksyxx',
  url: 'https://shell.blvcksyxx.xyz',
  github: 'https://github.com/blvcksyxx/blvcksyxx-shell',
  githubProfile: 'https://github.com/blvcksyxx',
  githubIssues: 'https://github.com/blvcksyxx/blvcksyxx-shell/issues',
  telegram: 'https://blvcksyxxchannel.t.me',
  personal: 'https://blvcksyxx.xyz',
  license:
    'https://github.com/blvcksyxx/blvcksyxx-shell/blob/main/LICENSE',
  installDocs:
    'https://github.com/blvcksyxx/blvcksyxx-shell/blob/main/docs/INSTALL.md',
  releases:
    'https://github.com/blvcksyxx/blvcksyxx-shell/releases/tag/v1.1',
  releaseNotes:
    'https://github.com/blvcksyxx/blvcksyxx-shell/blob/main/docs/releases/v1.1.md',
  version: 'v1.1',
  description:
    'blvcksyxx shell is a Linux desktop shell for Hyprland and niri: Task view, bar cards, widgets, dynamic island, control center and a Material 3 settings app.',
} as const;

export const nav = [
  { label: 'new', href: '#whats-new', icon: 'sparkles' },
  { label: 'previews', href: '#previews', icon: 'images' },
  { label: 'interface', href: '#interface', icon: 'panels-top-left' },
  { label: 'features', href: '#features', icon: 'grid-2x2' },
  { label: 'install', href: '#install', icon: 'terminal' },
  { label: 'faq', href: '#faq', icon: 'circle-help' },
] as const;

export const whatsNew = [
  {
    num: '01',
    title: 'Task view and Alt + Tab',
    body: 'Every workspace becomes a live screen with its windows. Type to find a window, drag it to another workspace, close it, or hold Alt and Tab through the windows you used last. On Hyprland and niri.',
    tags: ['SUPER + Tab', 'ALT + Tab', 'niri'],
  },
  {
    num: '02',
    title: 'Your keys, on one page',
    body: 'Settings > Keybinds now keeps the shell keys and your own commands together. Put any app or script on the keys you pick, including the Task view and the switcher.',
    tags: ['custom binds', 'search', 'pencil'],
  },
  {
    num: '03',
    title: 'Weather, System and Date on the bar',
    body: 'Three new bar modules grow out of their pill into Material 3 cards: the forecast, CPU / RAM / disk / swap, and the month with today and your tasks. They open beside a side bar too.',
    tags: ['bar cards', 'forecast', 'system'],
  },
  {
    num: '04',
    title: 'More widgets, smoother motion',
    body: 'Forecast, Music card and Date & time join the desktop. One Material You card style, a frame-rate choice (30, 60, 120 or Screen), and widgets that step back while windows are open.',
    tags: ['widgets', '120 Hz', 'Material You'],
  },
  {
    num: '05',
    title: 'Whole-look themes and app colors',
    body: 'Switch the entire shell in one click: blvcksyxx, Terminal, Glass, Neon, Ember or Frost. Carry the same palette into VSCodium / VS Code and Discord.',
    tags: ['6 themes', 'VSCode', 'Discord'],
  },
  {
    num: '06',
    title: 'Security and a safer updater',
    body: 'The Security page stays: ClamAV scans, system checks and a watch on the shell files. The Update Center keeps local changes aside when git pull cannot run, so an update still goes through.',
    tags: ['ClamAV', 'stash', 'rollback'],
  },
] as const;

export const previews = [
  {
    src: '/screenshots/settings-home.webp',
    alt: 'blvcksyxx shell Settings home with the welcome card, light mode switches and quick links',
    title: 'Settings · Home',
    caption: 'The whole desktop at a glance: theme, uptime, distro and the switches you reach for.',
    wide: true,
  },
  {
    src: '/screenshots/settings-bar.webp',
    alt: 'blvcksyxx shell Settings bar page with Dynamic island, auto-hide, shadow and position controls',
    title: 'Bar & island',
    caption: 'Six bar styles, auto-hide, shadows, side bars and the Dynamic island.',
    wide: false,
  },
  {
    src: '/screenshots/settings-theme.webp',
    alt: 'blvcksyxx shell Color theme page with Auto, Grey, six monochrome and thirteen fixed palettes',
    title: 'Color theme',
    caption: 'Twenty-one palettes: Auto and Grey from your wallpaper, six monochrome, thirteen colors.',
    wide: false,
  },
  {
    src: '/screenshots/settings-widgets.webp',
    alt: 'blvcksyxx shell Widgets page with Weather, Media, Resources, User card, Calendar and Visualizer toggles',
    title: 'Desktop widgets',
    caption: 'Frosted glass widgets, blur and transparency, and a frame rate for the moving parts.',
    wide: false,
  },
  {
    src: '/screenshots/settings-keybinds.webp',
    alt: 'blvcksyxx shell Keybinds page with searchable shortcut groups and editable key caps',
    title: 'Keybinds',
    caption: 'Every shell shortcut and your own keybinds on one searchable page.',
    wide: false,
  },
  {
    src: '/screenshots/settings-notifications.webp',
    alt: 'blvcksyxx shell Notifications page with a live example notification and pop-up placement controls',
    title: 'Notifications',
    caption: 'Google-style pop-ups, a live preview, action buttons and a notification center.',
    wide: true,
  },
  {
    src: '/screenshots/settings-update.webp',
    alt: 'blvcksyxx shell Update Center showing V1.1 is available with Update now and Check for updates buttons',
    title: 'Update Center · v1.1',
    caption: 'Update in place, with local changes kept aside if git pull needs room.',
    wide: false,
  },
] as const;

export const wallpaperPreviews = [
  {
    name: 'Nebula',
    src: '/wallpapers/space-nebula-1600.webp',
    jpg: '/wallpapers/space-nebula-1600.jpg',
  },
  {
    name: 'Galaxy',
    src: '/wallpapers/space-galaxy-1600.webp',
    jpg: '/wallpapers/space-galaxy-1600.jpg',
  },
  {
    name: 'Black hole',
    src: '/wallpapers/space-black-hole-1600.webp',
    jpg: '/wallpapers/space-black-hole-1600.jpg',
  },
  {
    name: 'Eclipse',
    src: '/wallpapers/space-eclipse-1600.webp',
    jpg: '/wallpapers/space-eclipse-1600.jpg',
  },
] as const;

export const platforms = [
  {
    id: 'arch',
    label: 'Arch',
    detail: 'Arch · CachyOS · EndeavourOS · Garuda',
    command: `sudo pacman -S --needed git base-devel
git clone https://github.com/blvcksyxx/blvcksyxx-shell && cd blvcksyxx-shell
./install.sh`,
  },
  {
    id: 'fedora',
    label: 'Fedora',
    detail: 'Fedora · Nobara · Bazzite commands',
    command: `sudo dnf install -y git
git clone https://github.com/blvcksyxx/blvcksyxx-shell && cd blvcksyxx-shell
./install.sh`,
  },
  {
    id: 'nixos',
    label: 'NixOS',
    detail: 'NixOS module · flakes or classic',
    command: `git clone https://github.com/blvcksyxx/blvcksyxx-shell && cd blvcksyxx-shell
# add to /etc/nixos/configuration.nix:
# imports = [ /path/to/blvcksyxx-shell/nix/module.nix ];
sudo nixos-rebuild switch && ./install.sh`,
  },
] as const;

export const requirements = [
  'Hyprland 0.55+ or niri 25.05+',
  'Quickshell, Wayland and the usual desktop tools',
  'Arch, CachyOS, EndeavourOS, Garuda, Fedora, Nobara or NixOS',
] as const;

export const faqs = [
  {
    q: 'What do I need to run blvcksyxx shell?',
    a: 'A Linux desktop with Hyprland 0.55+ or niri 25.05+, Quickshell and the usual Wayland tools. On the supported distributions the installer takes care of the packages, configs and first-run setup.',
  },
  {
    q: 'Which distributions are supported?',
    a: 'Arch Linux, CachyOS, EndeavourOS and Garuda follow the Arch route. Fedora and Nobara are supported through the project’s COPR packages. NixOS uses the included module. Bazzite and Silverblue get the rpm-ostree steps printed by the installer. Manjaro may not work because its Hyprland can be older than 0.55.',
  },
  {
    q: 'Will it overwrite my existing configuration?',
    a: 'Every file the installer replaces is copied to ~/.config/blvcksyxx-shell-backup-<time>/ first. Updates keep the files you changed, and ./install.sh --restore puts the last backup back.',
  },
  {
    q: 'Do I need an AUR helper?',
    a: 'No. On Arch, paru or yay are used when they are already installed; otherwise the installer sets up yay only if something the shell needs is missing from the official repositories.',
  },
  {
    q: 'How do updates work?',
    a: 'Run rice-update, or use Update now in the update notification or in Settings → Update Center. The updater fetches the newest version and keeps your configuration. If git pull cannot run, local changes are kept on a branch and in a stash.',
  },
  {
    q: 'Does it work on macOS?',
    a: 'No. blvcksyxx shell is built on Quickshell, Hyprland and niri, which are Linux / Wayland projects. The installer stops on macOS with a clear message instead of making a broken partial install. A macOS version would have to be a separate native application.',
  },
  {
    q: 'Can I carry my settings to another computer?',
    a: 'Yes. settings/ in the repository holds saved Settings choices. ./install.sh applies them on another machine and keeps the files you changed there.',
  },
  {
    q: 'Is it free?',
    a: 'Yes. blvcksyxx shell is open source under the MIT license. You can use, modify and share it, provided the copyright and permission notice in LICENSE stay with copies or substantial portions of the software.',
  },
] as const;
