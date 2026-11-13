import gsap from 'gsap';
import ScrollTrigger from 'gsap/ScrollTrigger';

declare global {
  interface Window {
    __motionReady?: boolean;
  }
}

const root = document.documentElement;
const reduceMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
window.__motionReady = true;
root.classList.remove('motion-fallback');

const $ = <T extends Element>(selector: string, scope: ParentNode = document) =>
  scope.querySelector<T>(selector);
const $$ = <T extends Element>(selector: string, scope: ParentNode = document) =>
  Array.from(scope.querySelectorAll<T>(selector));

/* ------------------------------------------------------------------ navigation */

function setupNavigation() {
  const nav = $<HTMLElement>('[data-nav]');
  const progress = $<HTMLElement>('[data-progress]');
  const sections = $$<HTMLElement>('main section[id]');
  const spies = $$<HTMLAnchorElement>('[data-spy]');

  let ticking = false;

  const update = () => {
    ticking = false;
    const y = window.scrollY;
    const doc = document.documentElement;
    const max = Math.max(1, doc.scrollHeight - window.innerHeight);
    const current = Math.min(1, Math.max(0, y / max));

    if (progress) progress.style.transform = `scaleX(${current})`;
    if (nav) nav.classList.toggle('is-scrolled', y > 24);

    const marker = window.innerHeight * 0.36;
    let activeId = '';
    for (const section of sections) {
      const top = section.offsetTop;
      const bottom = top + section.offsetHeight;
      if (top <= marker && bottom > marker) {
        activeId = section.id;
        break;
      }
    }

    for (const link of spies) {
      const active = link.dataset.spy === activeId;
      link.classList.toggle('is-active', active);
      if (active) {
        link.setAttribute('aria-current', 'true');
      } else {
        link.removeAttribute('aria-current');
      }
    }
  };

  const request = () => {
    if (ticking) return;
    ticking = true;
    window.requestAnimationFrame(update);
  };

  window.addEventListener('scroll', request, { passive: true });
  window.addEventListener('resize', request, { passive: true });
  update();
}

/* ------------------------------------------------------------------ tabs */

interface TabConfig {
  tabSelector: string;
  panelSelector: string;
  tabAttribute: string;
  panelAttribute: string;
  onChange?: (id: string, tab: HTMLButtonElement) => void;
}

function setupTabs(config: TabConfig) {
  const tabs = $$<HTMLButtonElement>(config.tabSelector);
  const panels = $$<HTMLElement>(config.panelSelector);
  if (!tabs.length || !panels.length) return;

  const activate = (id: string, focus = false) => {
    const selectedTab = tabs.find((tab) => tab.dataset[config.tabAttribute] === id);
    if (!selectedTab) return;

    for (const tab of tabs) {
      const active = tab === selectedTab;
      tab.classList.toggle('is-active', active);
      tab.setAttribute('aria-selected', active ? 'true' : 'false');
      tab.tabIndex = active ? 0 : -1;
      if (active && focus) tab.focus();
    }

    for (const panel of panels) {
      const active = panel.dataset[config.panelAttribute] === id;
      if (active) {
        panel.hidden = false;
        void panel.offsetWidth;
        window.requestAnimationFrame(() => panel.classList.add('is-active'));
      } else {
        panel.classList.remove('is-active');
        window.setTimeout(() => {
          if (!panel.classList.contains('is-active')) panel.hidden = true;
        }, 420);
      }
    }

    config.onChange?.(id, selectedTab);
  };

  for (const tab of tabs) {
    tab.addEventListener('click', () => {
      const id = tab.dataset[config.tabAttribute];
      if (id) activate(id);
    });

    tab.addEventListener('keydown', (event) => {
      const keys = ['ArrowRight', 'ArrowDown', 'ArrowLeft', 'ArrowUp', 'Home', 'End'];
      if (!keys.includes(event.key)) return;
      event.preventDefault();

      const index = tabs.indexOf(tab);
      let next = index;
      if (event.key === 'ArrowRight' || event.key === 'ArrowDown') next = (index + 1) % tabs.length;
      if (event.key === 'ArrowLeft' || event.key === 'ArrowUp') next = (index - 1 + tabs.length) % tabs.length;
      if (event.key === 'Home') next = 0;
      if (event.key === 'End') next = tabs.length - 1;

      const nextId = tabs[next].dataset[config.tabAttribute];
      if (nextId) activate(nextId, true);
    });
  }
}

function setupShowcase() {
  const label = $<HTMLElement>('[data-stage-label]');
  const num = $<HTMLElement>('[data-stage-num]');
  const detail = $<HTMLElement>('[data-stage-detail]');

  setupTabs({
    tabSelector: '[data-tab]',
    panelSelector: '[data-stage] .stage-panel',
    tabAttribute: 'tab',
    panelAttribute: 'panel',
    onChange: (_id, tab) => {
      const nextLabel = tab.dataset.label ?? '';
      const nextNum = tab.dataset.num ?? '';
      const nextDetail = tab.dataset.detail ?? '';

      const swap = (element: HTMLElement | null, value: string) => {
        if (!element) return;
        element.textContent = value;
        if (!reduceMotion) {
          element.animate(
            [
              { opacity: 0, transform: 'translateY(6px)' },
              { opacity: 1, transform: 'translateY(0)' },
            ],
            { duration: 360, easing: 'cubic-bezier(0.16, 1, 0.3, 1)' }
          );
        }
      };

      swap(label, nextLabel);
      swap(num, nextNum);
      swap(detail, nextDetail);
    },
  });
}

function setupInstallTabs() {
  setupTabs({
    tabSelector: '[data-install-tab]',
    panelSelector: '[data-install-panel]',
    tabAttribute: 'installTab',
    panelAttribute: 'installPanel',
  });
}

/* ------------------------------------------------------------------ copy buttons */

function fallbackCopy(text: string) {
  const area = document.createElement('textarea');
  area.value = text;
  area.setAttribute('readonly', '');
  area.style.position = 'fixed';
  area.style.opacity = '0';
  document.body.appendChild(area);
  area.select();
  const ok = document.execCommand('copy');
  document.body.removeChild(area);
  return ok;
}

function setupCopyButtons() {
  for (const button of $$<HTMLButtonElement>('[data-copy-target]')) {
    button.addEventListener('click', async () => {
      const target = document.getElementById(button.dataset.copyTarget ?? '');
      if (!target) return;
      const text = (target.textContent ?? '').trim();
      let copied = false;

      try {
        await navigator.clipboard.writeText(text);
        copied = true;
      } catch {
        copied = fallbackCopy(text);
      }

      if (!copied) return;

      const label = $<HTMLElement>('[data-copy-label]', button);
      const previous = label?.textContent ?? 'copy';
      button.dataset.copied = 'true';
      if (label) label.textContent = 'copied';

      window.setTimeout(() => {
        delete button.dataset.copied;
        if (label) label.textContent = previous;
      }, 1800);
    });
  }
}

/* ------------------------------------------------------------------ card spotlight */

function setupSpotlight() {
  if (reduceMotion || !window.matchMedia('(hover: hover) and (pointer: fine)').matches) return;

  for (const card of $$<HTMLElement>('[data-spot]')) {
    card.addEventListener('pointermove', (event) => {
      const rect = card.getBoundingClientRect();
      card.style.setProperty('--mx', `${event.clientX - rect.left}px`);
      card.style.setProperty('--my', `${event.clientY - rect.top}px`);
    });
  }
}

/* ------------------------------------------------------------------ motion */

async function setupMotion() {
  if (reduceMotion) {
    root.classList.add('reveal-fallback');
    for (const element of $$<HTMLElement>('[data-reveal], .intro')) {
      element.style.opacity = '1';
      element.style.transform = 'none';
    }
    return;
  }

  gsap.registerPlugin(ScrollTrigger);

  const intro = $$<HTMLElement>('.hero .intro');
  gsap.set(intro, { opacity: 0, y: 26 });
  const screen = $<HTMLElement>('[data-parallax-screen]');
  if (screen) gsap.set(screen, { opacity: 0, y: 38, scale: 0.986 });

  const timeline = gsap.timeline({
    defaults: { ease: 'power3.out' },
    delay: 0.08,
  });

  timeline.to(intro, {
    opacity: 1,
    y: 0,
    duration: 0.9,
    stagger: 0.075,
  });

  if (screen) {
    timeline.to(
      screen,
      { opacity: 1, y: 0, scale: 1, duration: 1.35, ease: 'power3.out' },
      0.24
    );
  }

  if (screen) {
    gsap.to(screen, {
      yPercent: -5,
      ease: 'none',
      scrollTrigger: {
        trigger: '.hero',
        start: 'top top',
        end: 'bottom top',
        scrub: 1,
      },
    });
  }

  const glow = $<HTMLElement>('[data-parallax-glow]');
  if (glow) {
    gsap.to(glow, {
      yPercent: -28,
      opacity: 0.25,
      ease: 'none',
      scrollTrigger: {
        trigger: '.hero',
        start: 'top top',
        end: 'bottom top',
        scrub: 1.2,
      },
    });
  }

  gsap.set('[data-reveal]', { opacity: 0, y: 30 });
  ScrollTrigger.batch('[data-reveal]', {
    start: 'top 88%',
    once: true,
    onEnter: (batch) =>
      gsap.to(batch, {
        opacity: 1,
        y: 0,
        duration: 0.9,
        stagger: 0.075,
        ease: 'power3.out',
        overwrite: true,
      }),
  });

  const principles = $$<HTMLElement>('.principle');
  if (principles.length) {
    gsap.set(principles, { opacity: 0, y: 24 });
    ScrollTrigger.batch(principles, {
      start: 'top 86%',
      once: true,
      onEnter: (batch) =>
        gsap.to(batch, {
          opacity: 1,
          y: 0,
          duration: 0.85,
          stagger: 0.09,
          ease: 'power3.out',
        }),
    });
  }

  const stats = $<HTMLElement>('.experience-stats');
  if (stats) {
    gsap.set(stats, { opacity: 0, y: 24 });
    ScrollTrigger.create({
      trigger: stats,
      start: 'top 88%',
      once: true,
      onEnter: () => gsap.to(stats, { opacity: 1, y: 0, duration: 0.9, ease: 'power3.out' }),
    });
  }

  const stage = $<HTMLElement>('[data-stage]');
  if (stage) {
    gsap.from(stage, {
      scale: 0.985,
      opacity: 0.6,
      duration: 1.1,
      ease: 'power3.out',
      scrollTrigger: { trigger: stage, start: 'top 82%', once: true },
    });
  }

  window.addEventListener('load', () => ScrollTrigger.refresh(), { once: true });
}

/* ------------------------------------------------------------------ boot */

setupNavigation();
setupShowcase();
setupInstallTabs();
setupCopyButtons();
setupSpotlight();
void setupMotion();
