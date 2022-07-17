# Config
> Configuration files for my workstations using `nixos`, `nix-darwin` and `home-manager`.

## Requirements

- [GNU Make](https://www.gnu.org/software/make/)
- [Nix](https://nixos.org/download.html)
- [Docker](https://www.docker.com/#)
- [Vagrant](https://www.vagrantup.com/)

## Background

| Host                                                       | Usage                              | Tools                      | Status |
| :--------------------------------------------------------- | :--------------------------------: | :------------------------: | :------: |
| [glaucus](https://en.wikipedia.org/wiki/Glaucus)           | vmware fusion dev workstation      | nixos / home-manager       | ✅ |
| [gaia](https://en.wikipedia.org/wiki/Gaia)                 | macos m1 (personal) workstation    | nix-darwin / home-manager  | ✅ |
| [demeter](https://en.wikipedia.org/wiki/Demeter)           | macos intel (personal) workstation | nix-darwin / home-manager  | ✅ |
| [atlas](https://en.wikipedia.org/wiki/atlas)               | home server                        | docker-compose             | ✅ |

## Usage
> *For MacOS Users on Apple Silicon Chips*:
> Before installing `gaia`, please run the following command to install `rosetta2` which is needed for the `nix-darwin` installation:
> ```bash
> softwareupdate --install-rosetta --agree-to-license
> ```

To install `gaia` on an M1 Mac, run the following command:
```bash
make install_gaia
```

To install `demeter` on an Intel Mac, run the following command:
```bash
make install_demeter
```

To install `glaucus` on VMware Fusion, run the following command:
```bash
make install_glaucus
```

To install `atlas`, run the following command:
```bash
make install_atlas
`

To reload local changes, run the following command:
```bash
make reload
```

## Notes
- In NixOS, only root can add new system-wide packages, so after rebooting VMware Fusion for the first time, run the following commands:
```bash
# login as root

# change password
passwd "your-username"

# reboot
reboot

# login as user

# create new keys
ssh-keygen -t ed25519 -C "your-email"
cat ~/.ssh/id_rsa.pub | pbcopy

# clone config repo
pclone config
make install_glacus
```
- I learned quite a bit of NixOS-specific concepts from Malloc47's [config repo](https://github.com/malloc47/config).
- Learning how to setup nextcloud on NixOS via this [blog post](https://jacobneplokh.com/how-to-setup-nextcloud-on-nixos/).
