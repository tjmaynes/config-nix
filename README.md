# Config
> Configuration files for my workstations using `nixos`, `nix-darwin` and `home-manager`.

## Requirements

- [GNU Make](https://www.gnu.org/software/make/)
- [Nix](https://nixos.org/download.html)

## Background

| Host                                                  | Usage                                       | Tools                       | Status |
| :---------------------------------------------------- | :-----------------------------------------: | :-------------------------: | :----: |
| [apollo](https://en.wikipedia.org/wiki/apollo)        | ubuntu dev workstation                      | ubuntu / home-manager       | ✅ |
| [glaucus](https://en.wikipedia.org/wiki/Glaucus)      | full nixos dev workstation                  | nixos / home-manager        | ✅ |
| [gaia](https://en.wikipedia.org/wiki/Gaia)            | macos apple silicon (personal) workstation  | nix-darwin / home-manager   | ✅ |
| [demeter](https://en.wikipedia.org/wiki/Demeter)      | macos intel (personal) workstation          | nix-darwin / home-manager   | ✅ |

## Usage
To install `gaia` on an Silicon Mac, run the following command:
```bash
make install_gaia
```

To install `demeter` on an Intel Mac, run the following command:
```bash
make install_demeter
```

To install `glaucus` on a new NixOS machine, run the following command:
```bash
make install_glaucus
```

To install `apollo` on a new Ubuntu machine, run the following command:
```bash
make install_apollo
```

To reload local changes, run the following command:
```bash
make reload
```

## Setting up NixOS on a new machine

```bash
# login as root
sudo -i

# download repo
curl -SL https://github.com/tjmaynes/config/archive/master.tar.gz | tar xz
cd config-main

# download dotfiles
rm -rf dotfiles
curl -SL https://github.com/tjmaynes/dotfiles/archive/master.tar.gz | tar xz
mv dotfiles-main dotfiles

# Cannot create partitions through automation
# -- too much headache and bugs with parted

parted /dev/sda

mklabel gpt

mkpart "BOOT" fat32 1MiB 3MiB \
  set 1 esp on

mkpart "root" ext4 1000MiB ${NIX_PARTITION}000MiB

mkpart "swap" linux-swap ${NIX_PARTITION}000MiB 100% \
  set 3 swap on

# run installer
./scripts/install.sh "glaucus" "nixos" "tjmaynes"

# change password
passwd "tjmaynes"

# reboot
reboot

# login as user in GUI

# open terminal
ctrl+enter

# create new keys
ssh-keygen -t ed25519 -C "your-email"
cat ~/.ssh/id_ed25519.pub | pbcopy

# clone config repo
pclone config
make install_glaucus
```

## Notes

- I learned quite a bit of NixOS-specific concepts from Malloc47's [config repo](https://github.com/malloc47/config).
- Learning how to setup nextcloud on NixOS via this [blog post](https://jacobneplokh.com/how-to-setup-nextcloud-on-nixos/).
