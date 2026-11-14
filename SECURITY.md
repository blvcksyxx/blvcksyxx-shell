# Security Policy

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
git -c gpg.ssh.allowedSignersFile=install/trusted-signers verify-tag v1.1
git -c gpg.ssh.allowedSignersFile=install/trusted-signers verify-commit HEAD
```

The private signing key is not in this repository. It is kept by the maintainer and in the
GitHub Actions secret used by `.github/workflows/release.yml`. A key rotation updates
`install/trusted-signers` and the release files.

## Downloaded files

The installer and the `rice-*` helpers use `bin/rice-download` for third-party files. It
accepts HTTPS only, requires an exact SHA-256, writes to a temporary file and replaces the
destination only after the checksum matches. The downloads are pinned to an exact release or
commit; mutable URLs such as `releases/latest` are not used.

This covers the fonts, cursor packs, Bibata cursor and matugen. Their pinned versions and
checksums are next to their URLs in `bin/rice-fonts`, `bin/rice-cursor` and `install.sh`.
Updating one means changing its URL and checksum together.

Weather is requested from `https://wttr.in`. AUR packages are built by `paru`/`yay`, which
run the checks in their `PKGBUILD`; they are not downloaded by `rice-download`.
