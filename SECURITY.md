# Security

blvcksyxx shell is a desktop shell: the installer copies scripts into `~/.local/bin`, they run
at login, and a few steps ask for sudo (packages, the input group, SDDM). This file says what
is checked, what is a choice, and what it does not protect against.

## Supported versions

Security fixes go to the newest `1.x` release and to `main`. Older releases do not receive
separate fixes.

## Reporting a vulnerability

Please do not open a public issue for a security problem. Use GitHub's private vulnerability
reporting:

https://github.com/blvcksyxx/blvcksyxx-shell/security/advisories/new

Include the shell version (`cat ~/.config/rice/version`), your distribution, the steps to
reproduce it and what an attacker could do. Do not access other people's data, and do not
publish the details before a fix is available.

## Signed releases and updates

Release tags are signed with the project's SSH signing key. The public key is in
[`install/trusted-signers`](install/trusted-signers):

```
SHA256:n/ILvwETafTMBy9wi162zxGxu6TL8M9i+GJKC3zOd0o
```

Every GitHub release also has these files:

- `blvcksyxx-shell-<version>.tar.gz` — the source archive
- `SHA256SUMS` — its SHA-256
- `SHA256SUMS.sig` — the SSH signature of `SHA256SUMS`
- `trusted-signers` — the public key used for that signature

Verify a downloaded release before running it:

```bash
ssh-keygen -Y verify -f trusted-signers -I blvcksyxx-release \
  -n blvcksyxx-release -s SHA256SUMS.sig < SHA256SUMS
sha256sum -c SHA256SUMS
```

`install.sh --update` fetches the update first, verifies that the exact commit is either a
signed `v*` tag or a signed commit from this key, and only then fast-forwards. If the
signature is missing or wrong, the update stops and nothing is changed. Local changes are
kept on a branch and in a stash when the history has to be reset. A checkout without a
signature can still be installed manually, but it is not an update path.

Check a clone with:

```bash
git -c gpg.ssh.allowedSignersFile=install/trusted-signers verify-tag v1.11
git -c gpg.ssh.allowedSignersFile=install/trusted-signers verify-commit HEAD
```

The private signing key is not in this repository. It is kept by the maintainer and in the
GitHub Actions secret used by `.github/workflows/release.yml`. A key rotation updates
`install/trusted-signers` and the release files.

## What the code checks

- **Updates only come from this project.** The origin must be
  `github.com/<owner>/blvcksyxx-shell` (a fork is allowed, a remote edited into the repo is
  not), and the exact commit that is checked out must carry a valid signature from the
  release key.
- **A changed installer is not started on its own.** An update that brings a new `install.sh`
  or `install/lib` shows the diffstat and asks in a terminal before anything is pulled; an
  update started from Settings opens a terminal with `rice-update` for that question instead
  of going on. `RICE_TRUST_UPDATE=1` is the explicit opt-out.
- **Downloads are verified before use.** The installer and the `rice-*` helpers use
  `bin/rice-download` for third-party files. It accepts HTTPS only, requires an exact
  SHA-256, writes to a temporary file and replaces the destination only after the checksum
  matches. The downloads are pinned to an exact release or commit; mutable URLs such as
  `releases/latest` are not used.
- **Archives cannot write outside their folder.** `install/lib/secure.sh` refuses absolute
  paths, `../` and links pointing out of the destination when it unpacks an archive.
- **The input group is opt-in.** Infinite Desktop reads `/dev/input`, so it needs it, but
  that permission lets every program you run read every keyboard on the machine.
  `./install.sh --input-group` (or Settings > Desktop > Infinite Desktop > Allow) enables it
  after saying so.

## What is a choice, not a default

All three are in Settings > Language & region > Online lookups.

- **Weather**: a place is required before any request (`rice-weather place "Warsaw"`);
  otherwise wttr.in would geolocate your IP. Until then the widgets show the cached answer
  or nothing. An install that already showed the weather keeps the place wttr.in had named.
  Requests use `https://wttr.in`.
- **Lyrics**: asking lrclib.net about the current song (artist and title) is off for new
  installs (`rice-lyrics on`). An install that already had lyrics keeps them on. Cached
  lyrics are used either way.
- **Update checks**: on by default, once a day (`every_minutes` in
  `~/.config/rice/update.json`), off with `rice-update watch off`.

## Downloaded files

This covers the fonts, cursor packs, Bibata cursor and matugen. Their pinned versions and
checksums are next to their URLs in `bin/rice-fonts`, `bin/rice-cursor` and `install.sh`.
Updating one means changing its URL and checksum together.

AUR packages are built by `paru`/`yay`, which run the checks in their `PKGBUILD`; they are
not downloaded by `rice-download`.

## Known limits

- **The signing key is the trust anchor.** The guards above stop a foreign remote, an
  unsigned commit and a silent installer swap, but whoever holds the signing key can still
  sign code. If that matters to you, run from your own fork and review what the update
  changes before answering "y".
- **`rice-security` integrity baseline is tamper-evident, not tamper-proof.** It is a hash
  list in your own `~/.config`, so it notices accidental or casual changes; a process
  running as you can rewrite it.
- **Local code is trusted.** The shell runs what is in `~/.config/quickshell` and
  `~/.config/hypr` at login. The checks above cover the path *into* your machine, not
  someone who can already write there.

## Checks

`tests/security.sh` runs on any machine (no Linux needed) and in CI on every push. CI also
runs ShellCheck, Python compilation, Qt 6 `qmllint`, a pinned-download guard and a signed
commit check.
