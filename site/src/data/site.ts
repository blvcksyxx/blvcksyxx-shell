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
    'https://github.com/blvcksyxx/blvcksyxx-shell/releases/tag/v2.1.0',
  releaseNotes:
    'https://github.com/blvcksyxx/blvcksyxx-shell/blob/main/docs/releases/v2.1.0.md',
  version: 'v2.1.0',
  description:
    'blvcksyxx shell is a Linux desktop shell for Hyprland and niri: Task view, bar cards, widgets, dynamic island, control center, a game library, privacy controls, local AI tools and a Material 3 settings app.',
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
    title: 'Windows, stacks and your own keys',
    body: 'Minimize with SUPER + H and bring the last one back with SUPER + SHIFT + H. SUPER + T starts a stack (tabs), SUPER + CTRL + Left / Right walks it, and SUPER + CTRL + SHIFT + Left / Right puts a window into it. Do not like a key? Settings > Keybinds turns any window manager key off so you can give it something of your own.',
    tags: ['SUPER + H', 'SUPER + T', 'custom keys'],
  },
  {
    num: '02',
    title: 'Login screen clocks',
    body: 'The SDDM login screen now has five clock styles: classic, stacked, center, pill and shapes. Classic is the default here. Pick one in Settings > Desktop > Idle & Lockscreen > Login screen, or with rice-sddm clock STYLE.',
    tags: ['5 clocks', 'classic default', 'rice-sddm'],
  },
  {
    num: '03',
    title: 'Launcher favourites',
    body: 'Right-click an app in the launcher, or press Ctrl + D, and it comes first with a star. Your most-used apps stay at the top without editing a config file.',
    tags: ['right click', 'Ctrl + D', 'star'],
  },
  {
    num: '04',
    title: 'Toolbox: games, notes and local text',
    body: 'SUPER + X opens a Toolbox with two new tabs. Games lists Steam, Lutris and menu games, with search and one click to launch. Auto summarizes, translates English and Russian, extracts facts and makes tasks with local Ollama. The Note tab now writes Markdown with Edit and Preview, and Chat can index your notes and answer with the files it used.',
    tags: ['games', 'Markdown', 'Ollama', 'RAG'],
  },
  {
    num: '05',
    title: 'Themes and your own key colour',
    body: 'Save the whole look you have now under a name, export it as JSON, import it on another computer. Or take any #RRGGBB colour in Settings > Appearance > Colors and the bar, notifications, widgets and apps are made from it. Themes live in ~/.config/rice/themes.',
    tags: ['theme editor', '#RRGGBB', 'export / import'],
  },
  {
    num: '06',
    title: 'Privacy, clipboard and a lighter shell',
    body: 'Settings > Security shows the microphone, camera and screen in use, locks the screen now, clears the clipboard, sets private DNS, switches the firewall and lists what Flatpak apps may reach. A new clipboard widget keeps the newest copies on the desktop. Under it all, V4.84 makes the shell much lighter: the task view lets its pictures go, waves draw 30 times a second, and Settings quits a minute after you close it unless you keep it ready.',
    tags: ['privacy', 'clipboard', 'lighter'],
  },
] as const;

export const previews = [
  {
    src: '/screenshots/settings-home.webp',
    alt: 'blvcksyxx shell Settings home with the welcome card, profiles and quick links',
    title: 'Settings · Home',
    caption: 'The whole desktop at a glance: theme, uptime, distro and the switches you reach for.',
    wide: true,
  },
  {
    src: '/screenshots/settings-toolbox-page.webp',
    alt: 'blvcksyxx shell Toolbox settings page with side, width, transparency and blur controls',
    title: 'Toolbox',
    caption: 'Games, local text work, Markdown notes and a chat that reads your files.',
    wide: false,
  },
  {
    src: '/screenshots/settings-keybinds.webp',
    alt: 'blvcksyxx shell Keybinds page with searchable shortcut groups and key caps',
    title: 'Keybinds',
    caption: 'Every shell key, and the window manager keys you free for your own actions.',
    wide: false,
  },
  {
    src: '/screenshots/settings-login.webp',
    alt: 'blvcksyxx shell Idle and Lockscreen page with a login screen clock preview',
    title: 'Login screen',
    caption: 'Classic, stacked, center, pill and shapes — Classic is the default.',
    wide: false,
  },
  {
    src: '/screenshots/settings-launcher.webp',
    alt: 'blvcksyxx shell Launcher page with Wallpaper, Onyx, Graphite, Midnight, Rose and Paper themes',
    title: 'Launcher',
    caption: 'Six looks, files and conversions; right-click an app to keep it first.',
    wide: false,
  },
  {
    src: '/screenshots/settings-theme.webp',
    alt: 'blvcksyxx shell Themes page with six whole looks and your own saved themes',
    title: 'Themes',
    caption: 'Six whole looks, your own saved themes, export and import as JSON.',
    wide: false,
  },
  {
    src: '/screenshots/settings-colors.webp',
    alt: 'blvcksyxx shell Colors page with every color role and a custom key color field',
    title: 'Colors',
    caption: 'Every role, plus any #RRGGBB as the shell’s key colour.',
    wide: false,
  },
  {
    src: '/screenshots/settings-security.webp',
    alt: 'blvcksyxx shell Security page with devices in use, autolock, clipboard, private DNS, firewall and app permissions',
    title: 'Security & privacy',
    caption: 'Devices in use, autolock, clipboard, DNS, firewall and Flatpak permissions.',
    wide: false,
  },
  {
    src: '/screenshots/settings-update.webp',
    alt: 'blvcksyxx shell Update Center showing V2.1.0 is up to date',
    title: 'Update Center · v2.1.0',
    caption: 'You are up to date. Signed updates, local changes kept aside.',
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
    src: '/screenshots/settings-widgets.webp',
    alt: 'blvcksyxx shell Widgets page with Weather, Media, Resources, User card, Calendar and Visualizer toggles',
    title: 'Desktop widgets',
    caption: 'Frosted glass widgets, blur, transparency and a frame rate for the moving parts.',
    wide: false,
  },
  {
    src: '/screenshots/settings-notifications.webp',
    alt: 'blvcksyxx shell Notifications page with a live example notification and pop-up placement controls',
    title: 'Notifications',
    caption: 'Google-style pop-ups, a live preview, action buttons and a notification center.',
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
