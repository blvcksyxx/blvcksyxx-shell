import { defineConfig } from 'astro/config';
import sitemap from '@astrojs/sitemap';
import tailwindcss from '@tailwindcss/vite';

const siteUrl = 'https://shell.blvcksyxx.xyz';
const updated = new Date('2026-11-21T00:00:00Z');

const screenshots = [
  ['settings-home.webp', 'blvcksyxx shell Settings home', 'Settings home with the welcome card and quick switches'],
  ['settings-bar.webp', 'blvcksyxx shell bar settings', 'Six bar styles, auto-hide, shadows and the Dynamic island'],
  ['settings-theme.webp', 'blvcksyxx shell themes', 'Six whole-look themes and your own saved themes'],
  ['settings-colors.webp', 'blvcksyxx shell colours', 'Every colour role and a custom #RRGGBB key colour'],
  ['settings-widgets.webp', 'blvcksyxx shell desktop widgets', 'Weather, media, resources, calendar and visualizer widgets'],
  ['settings-keybinds.webp', 'blvcksyxx shell keybinds', 'Shell shortcuts and the window manager keys you free for your own actions'],
  ['settings-toolbox.webp', 'blvcksyxx shell Toolbox', 'Games, local text work, Markdown notes and a chat that reads your files'],
  ['settings-login.webp', 'blvcksyxx shell login screen clocks', 'Classic, stacked, center, pill and shapes for the SDDM login screen'],
  ['settings-launcher.webp', 'blvcksyxx shell launcher', 'Six looks, files, conversions and favourites'],
  ['settings-security.webp', 'blvcksyxx shell security and privacy', 'Devices in use, autolock, clipboard, private DNS, firewall and Flatpak permissions'],
  ['settings-notifications.webp', 'blvcksyxx shell notifications', 'Google-style notification pop-ups with a live preview'],
  ['settings-update.webp', 'blvcksyxx shell Update Center', 'Update to v2.1.0 without losing local changes'],
];

const wallpapers = [
  ['space-nebula-1600.jpg', 'Nebula wallpaper'],
  ['space-galaxy-1600.jpg', 'Galaxy wallpaper'],
  ['space-black-hole-1600.jpg', 'Black hole wallpaper'],
  ['space-eclipse-1600.jpg', 'Eclipse wallpaper'],
];

const images = [
  ...screenshots.map(([file, title, caption]) => ({
    url: `${siteUrl}/screenshots/${file}`,
    title,
    caption,
  })),
  ...wallpapers.map(([file, title]) => ({
    url: `${siteUrl}/wallpapers/${file}`,
    title,
    caption: `${title} included with blvcksyxx shell`,
  })),
];

export default defineConfig({
  site: siteUrl,
  output: 'static',
  trailingSlash: 'never',
  integrations: [
    sitemap({
      filter: (page) => !page.includes('/__og-preview'),
      serialize(item) {
        if (item.url === `${siteUrl}/`) {
          return {
            ...item,
            lastmod: updated.toISOString(),
            changefreq: 'weekly',
            priority: 1,
            img: images,
          };
        }
        return item;
      },
    }),
  ],
  vite: {
    plugins: [tailwindcss()],
  },
  build: {
    inlineStylesheets: 'auto',
  },
});
