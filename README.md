# Aarklendoia's Gentoo overlay

Gentoo ebuilds for:

| Package | Upstream |
|---|---|
| `kde-misc/kio-protondrive` | [Aarklendoia/kio-protondrive](https://github.com/Aarklendoia/kio-protondrive): Proton Drive in Dolphin and other KIO applications |

## Usage

```bash
sudo eselect repository add aarklendoia git https://github.com/Aarklendoia/gentoo-overlay.git
sudo emaint sync -r aarklendoia
```

The packages are keyworded `~amd64` only, and `kde-misc/kio-protondrive`
needs `dev-build/corrosion`, which is `~amd64` in ::gentoo too:

```bash
printf '%s\n' 'kde-misc/kio-protondrive ~amd64' 'dev-build/corrosion ~amd64' \
  | sudo tee /etc/portage/package.accept_keywords/kio-protondrive
sudo emerge --ask kde-misc/kio-protondrive
```

Updates arrive with `emaint sync -r aarklendoia` (or `emerge --sync`).

## Maintenance

`kde-misc/kio-protondrive` is updated automatically on each upstream
release: its `build-gentoo.yml` workflow builds the ebuild with emerge
(tests included) and pushes it here. Report problems
[upstream](https://github.com/Aarklendoia/kio-protondrive/issues).

This overlay isn't part of Gentoo and isn't supported by Gentoo developers.
The ebuilds are distributed under the GNU General Public License v2, like
::gentoo's.
