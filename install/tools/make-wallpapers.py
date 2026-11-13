#!/usr/bin/env python3
"""Generate the wallpapers included with blvcksyxx shell.

Original artwork made for this repository; MIT, like the rest of the code.
Requires ImageMagick 7 (`magick`) on the machine that regenerates them; the
installer only copies the finished JPEGs.

    python3 install/tools/make-wallpapers.py
"""
import math
import os
import random
import subprocess

W, H = 2560, 1440
ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))


def svg(body, defs=""):
    return (
        f'<svg xmlns="http://www.w3.org/2000/svg" width="{W}" height="{H}" '
        f'viewBox="0 0 {W} {H}"><defs>{COMMON}{defs}</defs>{body}</svg>'
    )


COMMON = """
<filter id="soft" x="-25%" y="-25%" width="150%" height="150%"><feGaussianBlur stdDeviation="30"/></filter>
<filter id="soft2" x="-35%" y="-35%" width="170%" height="170%"><feGaussianBlur stdDeviation="80"/></filter>
<filter id="soft3" x="-20%" y="-20%" width="140%" height="140%"><feGaussianBlur stdDeviation="10"/></filter>
<filter id="grain" x="0" y="0" width="100%" height="100%">
  <feTurbulence type="fractalNoise" baseFrequency="0.85" numOctaves="2" seed="7" result="n"/>
  <feColorMatrix in="n" type="saturate" values="0"/>
</filter>
"""


def stars(rng, n, ymax=1.0, color="#ffffff", maxr=1.8):
    out = []
    for _ in range(n):
        out.append(
            '<circle cx="%.1f" cy="%.1f" r="%.2f" fill="%s" opacity="%.2f"/>'
            % (rng.uniform(0, W), rng.uniform(0, H * ymax), rng.uniform(0.3, maxr), color, rng.uniform(0.2, 0.95))
        )
    return "".join(out)


def grain(opacity=0.05):
    return f'<rect width="{W}" height="{H}" filter="url(#grain)" opacity="{opacity}"/>'


def ridge(rng, base, amp, step=100):
    pts, x, y = [], 0, base
    while x <= W:
        y = max(base - amp * 2.1, min(base + amp * 1.4, y + rng.uniform(-amp, amp)))
        pts.append((x, y))
        x += rng.uniform(step * 0.5, step * 1.5)
    pts.append((W, base + rng.uniform(-amp, amp)))
    path = f"M0,{H} L0,{pts[0][1]:.1f} " + " ".join("L%.1f,%.1f" % p for p in pts) + f" L{W},{H} Z"
    return path


def wave(rng, base, amp, step=70, phase=0.0):
    pts = []
    for x in range(-100, W + 200, step):
        y = base + amp * math.sin(x / 310 + phase) + amp * 0.42 * math.sin(x / 91 + phase * 2.7)
        pts.append((x, y))
    path = f"M-100,{H} L-100,{pts[0][1]:.1f} " + " ".join("L%.1f,%.1f" % p for p in pts) + f" L{W+100},{H} Z"
    return path


def peaks(rng, sky, layers, moon=None, warm=False):
    defs = f"""
    <linearGradient id="sky" x1="0" y1="0" x2="0" y2="1">{sky}</linearGradient>
    <radialGradient id="glow"><stop offset="0" stop-color="{'#ffd9a0' if warm else '#ffffff'}" stop-opacity=".55"/><stop offset="1" stop-color="{'#ffd9a0' if warm else '#ffffff'}" stop-opacity="0"/></radialGradient>
    """
    body = [f'<rect width="{W}" height="{H}" fill="url(#sky)"/>']
    if moon:
        mx, my, mr, color = moon
        body.append(f'<circle cx="{mx}" cy="{my}" r="{mr*3.2:.0f}" fill="url(#glow)" filter="url(#soft)"/>')
        body.append(f'<circle cx="{mx}" cy="{my}" r="{mr}" fill="{color}"/>')
    body.append(stars(rng, 260 if moon else 80, 0.62, color="#ffe9d0" if warm else "#ffffff", maxr=1.4))
    for color, base, amp, op in layers:
        body.append(f'<path d="{ridge(rng, base, amp)}" fill="{color}" opacity="{op}"/>')
        body.append(f'<rect y="{base}" width="{W}" height="260" fill="url(#glow)" opacity=".05" filter="url(#soft2)"/>')
    body.append(grain(0.045))
    return svg("".join(body), defs)


def aurora(rng, horizon=False):
    defs = """
    <linearGradient id="sky" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#02030a"/><stop offset=".62" stop-color="#071228"/><stop offset="1" stop-color="#123055"/></linearGradient>
    <linearGradient id="g1" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#5affc0" stop-opacity="0"/><stop offset=".5" stop-color="#5affc0" stop-opacity=".85"/><stop offset="1" stop-color="#3b7dff" stop-opacity="0"/></linearGradient>
    <linearGradient id="g2" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#b06bff" stop-opacity="0"/><stop offset=".5" stop-color="#b06bff" stop-opacity=".6"/><stop offset="1" stop-color="#3de1ff" stop-opacity="0"/></linearGradient>
    <radialGradient id="planet" cx="50%" cy="0%" r="80%"><stop offset="0" stop-color="#1a3a62"/><stop offset="1" stop-color="#050a18"/></radialGradient>
    """
    body = [f'<rect width="{W}" height="{H}" fill="url(#sky)"/>', stars(rng, 520, 0.9, maxr=1.7)]
    for i, grad in enumerate(["url(#g1)", "url(#g2)", "url(#g1)"]):
        y = 430 + i * 150
        path = wave(rng, y, 130 + i * 25, phase=i * 1.7)
        body.append(f'<path d="{path}" fill="{grad}" filter="url(#soft)" opacity="{0.85 - i * 0.16:.2f}"/>')
    if horizon:
        body.append(f'<ellipse cx="1280" cy="1640" rx="1900" ry="620" fill="url(#planet)"/>')
        body.append(f'<ellipse cx="1280" cy="1640" rx="1900" ry="620" fill="none" stroke="#5fc8ff" stroke-width="5" opacity=".35"/>')
    body.append(grain(0.045))
    return svg("".join(body), defs)


def nebula(rng):
    defs = """
    <radialGradient id="pink"><stop offset="0" stop-color="#ff4f9a" stop-opacity=".9"/><stop offset=".55" stop-color="#8a1bd4" stop-opacity=".45"/><stop offset="1" stop-color="#050510" stop-opacity="0"/></radialGradient>
    <radialGradient id="blue"><stop offset="0" stop-color="#4fd8ff" stop-opacity=".8"/><stop offset=".6" stop-color="#1b4bd4" stop-opacity=".3"/><stop offset="1" stop-color="#050510" stop-opacity="0"/></radialGradient>
    <radialGradient id="violet"><stop offset="0" stop-color="#c86bff" stop-opacity=".75"/><stop offset="1" stop-color="#050510" stop-opacity="0"/></radialGradient>
    <filter id="tex" x="0" y="0" width="100%" height="100%">
      <feTurbulence type="fractalNoise" baseFrequency="0.004 0.009" numOctaves="5" seed="11" result="n"/>
      <feColorMatrix in="n" type="saturate" values="0" result="g"/>
      <feComponentTransfer in="g"><feFuncA type="table" tableValues="0 0 .65"/></feComponentTransfer>
      <feGaussianBlur stdDeviation="2.5"/>
    </filter>
    <mask id="m"><rect width="100%" height="100%" fill="#000"/><ellipse cx="1300" cy="760" rx="1120" ry="620" fill="#fff" filter="url(#soft2)"/></mask>
    """
    body = [f'<rect width="{W}" height="{H}" fill="#04040c"/>', '<g mask="url(#m)">']
    body.append(f'<ellipse cx="920" cy="620" rx="840" ry="440" fill="url(#pink)" filter="url(#soft)"/>')
    body.append(f'<ellipse cx="1620" cy="820" rx="780" ry="470" fill="url(#blue)" filter="url(#soft)"/>')
    body.append(f'<ellipse cx="1250" cy="470" rx="440" ry="270" fill="url(#violet)" filter="url(#soft)"/>')
    body.append('</g>')
    body.append('<g mask="url(#m)">')
    body.append(f'<rect width="{W}" height="{H}" filter="url(#tex)" opacity=".35"/>')
    body.append('</g>')
    body.append(stars(rng, 560, 1.0, maxr=2.0))
    body.append(grain(0.035))
    return svg("".join(body), defs)


def galaxy(rng):
    defs = """
    <radialGradient id="core"><stop offset="0" stop-color="#fff6e0"/><stop offset=".22" stop-color="#ffd9a0" stop-opacity=".95"/><stop offset=".55" stop-color="#c77dff" stop-opacity=".4"/><stop offset="1" stop-color="#050510" stop-opacity="0"/></radialGradient>
    <radialGradient id="halo"><stop offset="0" stop-color="#7fb2ff" stop-opacity=".32"/><stop offset="1" stop-color="#050510" stop-opacity="0"/></radialGradient>
    """
    body = [f'<rect width="{W}" height="{H}" fill="#04040b"/>', stars(rng, 650, 1.0, maxr=1.9)]
    cx, cy = W // 2, H // 2
    body.append(f'<ellipse cx="{cx}" cy="{cy}" rx="1050" ry="360" fill="url(#halo)" filter="url(#soft)" transform="rotate(-22 {cx} {cy})"/>')
    for arm in range(3):
        body.append(f'<g transform="rotate({arm * 120 - 22} {cx} {cy})">')
        for i in range(420):
            t = rng.uniform(0.12, 1.0)
            a = t * 6.2 + rng.uniform(-0.35, 0.35)
            r = 90 + t * 820
            x = cx + math.cos(a) * r + rng.uniform(-38, 38)
            y = cy + math.sin(a) * r * 0.34 + rng.uniform(-22, 22)
            hot = rng.random()
            color = "#fff2cf" if hot > 0.82 else ("#b9c9ff" if hot > 0.45 else "#8a6bff")
            body.append('<circle cx="%.1f" cy="%.1f" r="%.2f" fill="%s" opacity="%.2f"/>' % (x, y, rng.uniform(0.7, 2.6), color, rng.uniform(0.12, 0.8)))
        body.append('</g>')
    body.append(f'<circle cx="{cx}" cy="{cy}" r="300" fill="url(#core)" filter="url(#soft3)"/>')
    body.append(f'<circle cx="{cx}" cy="{cy}" r="78" fill="#fff8e8" opacity=".85" filter="url(#soft3)"/>')
    body.append(grain(0.035))
    return svg("".join(body), defs)


def black_hole(blue=False):
    hot = "#8fd8ff" if blue else "#ffb15a"
    mid = "#3f7dff" if blue else "#ff5a2b"
    defs = f"""
    <radialGradient id="disk"><stop offset="0" stop-color="{hot}" stop-opacity=".95"/><stop offset=".5" stop-color="{mid}" stop-opacity=".8"/><stop offset="1" stop-color="{mid}" stop-opacity="0"/></radialGradient>
    <radialGradient id="halo"><stop offset="0" stop-color="{hot}" stop-opacity=".45"/><stop offset="1" stop-color="{hot}" stop-opacity="0"/></radialGradient>
    """
    body = [f'<rect width="{W}" height="{H}" fill="#030308"/>', stars(rng_global, 640, 1.0, maxr=1.8)]
    body.append(f'<circle cx="1280" cy="720" r="560" fill="url(#halo)" filter="url(#soft2)"/>')
    body.append('<g transform="rotate(-15 1280 720)">')
    for i in range(5):
        rx, ry = 390 + i * 58, 92 + i * 19
        body.append(f'<ellipse cx="1280" cy="720" rx="{rx}" ry="{ry}" fill="none" stroke="url(#disk)" stroke-width="{34 - i * 4}" opacity="{0.9 - i * 0.12:.2f}" filter="url(#soft3)"/>')
    body.append('</g>')
    body.append('<circle cx="1280" cy="720" r="252" fill="#000000"/>')
    body.append(f'<circle cx="1280" cy="720" r="255" fill="none" stroke="{hot}" stroke-width="6" opacity=".7" filter="url(#soft3)"/>')
    body.append('<g transform="rotate(-15 1280 720)">')
    body.append(f'<path d="M430,780 A850,220 0 0 0 2130,780" fill="none" stroke="{hot}" stroke-width="20" opacity=".55" filter="url(#soft3)"/>')
    body.append('</g>')
    body.append(grain(0.04))
    return svg("".join(body), defs)


def eclipse(rng):
    defs = """
    <radialGradient id="corona"><stop offset=".5" stop-color="#fff2cf" stop-opacity="0"/><stop offset=".61" stop-color="#ffcf7a" stop-opacity=".95"/><stop offset=".72" stop-color="#ff7a3d" stop-opacity=".5"/><stop offset="1" stop-color="#ff4d6d" stop-opacity="0"/></radialGradient>
    <radialGradient id="sky"><stop offset="0" stop-color="#241033"/><stop offset=".55" stop-color="#0a0a18"/><stop offset="1" stop-color="#030308"/></radialGradient>
    """
    body = [f'<rect width="{W}" height="{H}" fill="url(#sky)"/>', stars(rng, 600, 1.0, maxr=1.7)]
    body.append('<circle cx="1280" cy="700" r="640" fill="url(#corona)" filter="url(#soft)"/>')
    body.append('<circle cx="1280" cy="700" r="360" fill="#05050c"/>')
    body.append('<circle cx="1280" cy="700" r="363" fill="none" stroke="#fff1c9" stroke-width="5" opacity=".9" filter="url(#soft3)"/>')
    body.append('<circle cx="1280" cy="700" r="388" fill="none" stroke="#ffb36a" stroke-width="10" opacity=".45" filter="url(#soft3)"/>')
    body.append(grain(0.04))
    return svg("".join(body), defs)


def planet(rng):
    defs = """
    <linearGradient id="sky" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#05050f"/><stop offset=".55" stop-color="#0d1730"/><stop offset="1" stop-color="#1a0d2a"/></linearGradient>
    <radialGradient id="ball" cx="38%" cy="32%" r="75%"><stop offset="0" stop-color="#ffd9a8"/><stop offset=".42" stop-color="#d98a5a"/><stop offset=".72" stop-color="#6b3a5a"/><stop offset="1" stop-color="#120b1c"/></radialGradient>
    <linearGradient id="ring" x1="0" y1="0" x2="1" y2="0"><stop offset="0" stop-color="#f6d7a8" stop-opacity=".1"/><stop offset=".3" stop-color="#f6d7a8" stop-opacity=".85"/><stop offset=".7" stop-color="#b98a6a" stop-opacity=".7"/><stop offset="1" stop-color="#f6d7a8" stop-opacity=".1"/></linearGradient>
    """
    body = [f'<rect width="{W}" height="{H}" fill="url(#sky)"/>', stars(rng, 560, 1.0, maxr=1.7)]
    body.append('<g transform="rotate(-18 1280 760)">')
    body.append('<ellipse cx="1280" cy="760" rx="900" ry="150" fill="none" stroke="url(#ring)" stroke-width="54" opacity=".8"/>')
    body.append('<ellipse cx="1280" cy="760" rx="760" ry="118" fill="none" stroke="url(#ring)" stroke-width="26" opacity=".6"/>')
    body.append('</g>')
    body.append('<circle cx="1280" cy="680" r="360" fill="url(#ball)"/>')
    body.append('<g transform="rotate(-18 1280 760)">')
    body.append('<path d="M380,760 A900,150 0 0 0 2180,760" fill="none" stroke="url(#ring)" stroke-width="54" opacity=".95"/>')
    body.append('</g>')
    body.append(grain(0.04))
    return svg("".join(body), defs)


def waves(rng):
    defs = """
    <linearGradient id="bg" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#101014"/><stop offset="1" stop-color="#2a2a30"/></linearGradient>
    <linearGradient id="a" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#e8e8ee" stop-opacity=".8"/><stop offset="1" stop-color="#8a8a98" stop-opacity=".08"/></linearGradient>
    <linearGradient id="b" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#9a9aa8" stop-opacity=".5"/><stop offset="1" stop-color="#3a3a44" stop-opacity="0"/></linearGradient>
    """
    body = [f'<rect width="{W}" height="{H}" fill="url(#bg)"/>']
    for i in range(12):
        body.append(f'<path d="{wave(rng, 80 + i * 112, 38 + i * 6, phase=i * 0.8)}" fill="url(#{"a" if i % 2 == 0 else "b"})" opacity="{0.6 - i * 0.035:.2f}"/>')
    body.append(grain(0.05))
    return svg("".join(body), defs)


rng_global = random.Random(7)


def build():
    images = {
        "aurora": lambda r: aurora(r),
        "dawn-ridge": lambda r: peaks(
            r,
            '<stop offset="0" stop-color="#27203b"/><stop offset=".38" stop-color="#8b4a63"/><stop offset=".66" stop-color="#e88a6a"/><stop offset=".85" stop-color="#f6c48a"/>',
            [("#6b4a5e", 820, 70, .55), ("#4a3348", 930, 95, .7), ("#2e2033", 1050, 130, .85), ("#160f1a", 1180, 165, .95)],
            moon=(1280, 760, 130, "#ffe7b0"), warm=True,
        ),
        "grey-waves": waves,
        "mono-peaks": lambda r: peaks(
            r,
            '<stop offset="0" stop-color="#08080a"/><stop offset=".55" stop-color="#1b1b20"/><stop offset="1" stop-color="#3a3a42"/>',
            [("#4a4a54", 760, 90, .55), ("#34343c", 870, 120, .62), ("#222228", 1000, 150, .7), ("#101014", 1140, 190, .78)],
            moon=(1840, 360, 118, "#f0f0f4"),
        ),
        "night-peaks": lambda r: peaks(
            r,
            '<stop offset="0" stop-color="#05070f"/><stop offset=".55" stop-color="#0b1330"/><stop offset="1" stop-color="#18244a"/>',
            [("#23305c", 800, 80, .8), ("#172044", 930, 120, .85), ("#0d1430", 1060, 160, .9), ("#050814", 1190, 190, .95)],
            moon=(1980, 290, 92, "#e6eeff"),
        ),
        "space-aurora": lambda r: aurora(r, horizon=True),
        "space-black-hole-blue": lambda r: black_hole(True),
        "space-black-hole": lambda r: black_hole(False),
        "space-eclipse": eclipse,
        "space-galaxy": galaxy,
        "space-nebula": nebula,
        "space-planet": planet,
    }
    walls = os.path.join(ROOT, "wallpapers")
    site = os.path.join(ROOT, "site", "public", "wallpapers")
    os.makedirs(walls, exist_ok=True)
    os.makedirs(site, exist_ok=True)
    for name, maker in images.items():
        rng = random.Random(name)
        svg_path = os.path.join("/tmp", "blvcksyxx-" + name + ".svg")
        open(svg_path, "w").write(maker(rng))
        subprocess.run(["magick", svg_path, "-quality", "92", os.path.join(walls, name + ".jpg")], check=True)
        os.unlink(svg_path)
        print("wallpapers/" + name + ".jpg")
    for name, widths in {
        "mono-peaks": (800, 1600),
        "space-nebula": (1600,),
        "space-galaxy": (1600,),
        "space-black-hole": (1600,),
        "space-eclipse": (1600,),
    }.items():
        for width in widths:
            height = width * 9 // 16
            jpg = os.path.join(site, "%s-%d.jpg" % (name, width))
            webp = os.path.join(site, "%s-%d.webp" % (name, width))
            subprocess.run(["magick", os.path.join(walls, name + ".jpg"), "-resize", "%dx%d^" % (width, height),
                            "-gravity", "center", "-extent", "%dx%d" % (width, height), "-quality", "88", jpg], check=True)
            subprocess.run(["magick", jpg, "-quality", "82", webp], check=True)
            print("site/public/wallpapers/" + os.path.basename(jpg))


if __name__ == "__main__":
    build()
