#!/bin/sh

set -e

HOST_NAME=$1
NIXOS_USERNAME=$2

function check_requirements() {
  if [[ -z "$HOST_NAME" ]]; then
    echo "Please provide a HOST_NAME arg"
    exit 1
  elif [[ -z "$NIXOS_USERNAME" ]]; then
    echo "Please provide a NIXOS_USERNAME arg"
    exit 1
  fi
}

function install_nixpkgs() {
  nix-channel --add "https://nixos.org/channels/nixpkgs-unstable" nixpkgs
  nix-channel --update
}

function install_home_manager() {
  nix-channel --add "https://github.com/nix-community/home-manager/archive/master.tar.gz" home-manager
  nix-channel --update
}

function install_nix_darwin() {
  if [[ ! "$HOME/.config/nixpkgs" -ef "$(pwd)/hosts" ]]; then
    rm -rf "$HOME/.config/nixpkgs"
    (mkdir -p "$HOME/.config" || true) && ln -s "$(pwd)/hosts" "$HOME/.config/nixpkgs"
  fi

  if [[ ! "$(readlink $HOME/.nixpkgs/darwin-configuration.nix)" -ef "$(pwd)/hosts/$HOST_NAME.nix" ]]; then
    rm -rf "$HOME/.nixpkgs/darwin-configuration.nix"
    (mkdir -p "$HOME/.nixpkgs" || true) && ln -s "$(pwd)/hosts/$HOST_NAME.nix" "$HOME/.nixpkgs/darwin-configuration.nix"
  fi

  if [[ ! -f "$(pwd)/result/bin/darwin-installer" ]]; then
    nix-build -I nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixpkgs "https://github.com/LnL7/nix-darwin/archive/master.tar.gz" -A installer
  fi

  ./result/bin/darwin-installer
}

function install_darwin_based_host() {
  if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "Please run this script on a Darwin-based machine"
    exit 1
  fi

  export PATH=/usr/sbin:$PATH
  export NIX_PATH=$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH
  export NIX_PATH=darwin-config=$HOME/.nixpkgs/darwin-configuration.nix:$NIX_PATH
  export NIX_PATH=nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixpkgs:$NIX_PATH

  if [[ -z "$(command -v git)" ]]; then
    xcode-select --install
  fi

  if [ "$(uname -m)" = "arm64" ]; then
    export PATH=/opt/homebrew/bin:$PATH
  else
    export PATH=/usr/local/bin:$PATH
  fi

  if [[ -z "$(command -v brew)" ]]; then
    /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  if [[ -z "$(command -v nix)" ]]; then
    /bin/sh -c "$(curl -fsSL https://nixos.org/nix/install)" --darwin-use-unencrypted-nix-store-volume --daemon
  fi

  [[ -f "/etc/nix/nix.conf" ]] && sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.backup
  [[ -f "/etc/shells" ]] && sudo mv /etc/shells /etc/shells.backup

  install_nixpkgs
  install_home_manager
  install_nix_darwin
}

function install_nixos_based_host() {
  if [[ ! -d "/etc/nixos" ]]; then
    parted /dev/sda -- mklabel gpt
    parted /dev/sda -- mkpart primary 512MiB -8GiB
    parted /dev/sda -- mkpart primary linux-swap -8GiB 100%
    parted /dev/sda -- mkpart ESP fat32 1MiB 512MiB
    parted /dev/sda -- set 3 esp on

    mkfs.ext4 -L nixos /dev/sda1
    mkswap -L swap /dev/sda2
    swapon /dev/sda2
    mkfs.fat -F 32 -n boot /dev/sda3        # (for UEFI systems only)
    mount /dev/disk/by-label/nixos /mnt
    mkdir -p /mnt/boot                      # (for UEFI systems only)
    mount /dev/disk/by-label/boot /mnt/boot # (for UEFI systems only)

    nixos-generate-config --root /mnt

    if [[ ! "/mnt/etc/nixos/configuration.nix" -ef "$(pwd)/hosts/$HOST_NAME.nix" ]]; then
      (rm -rf /mnt/etc/nixos/configuration.nix) && ln -s "$(pwd)/hosts/$HOST_NAME.nix" "/mnt/etc/nixos/configuration.nix"
    fi

    install_home_manager
    nixos-install

    if [[ "whoami" -eq "root" ]]; then
      if ! id "$NIXOS_USERNAME" &>/dev/null; then
        useradd -c '"$NIXOS_USERNAME"' -m "$NIXOS_USERNAME"
        passwd "$NIXOS_USERNAME"
      fi
    fi

    reboot
  else
    sudo nix-channel --add "https://nixos.org/channels/nixpkgs-unstable" nixpkgs
    sudo nix-channel --update

    sudo nix-channel --add "https://github.com/nix-community/home-manager/archive/master.tar.gz" home-manager
    sudo nix-channel --update

    if [[ ! "/etc/nixos/configuration.nix" -ef "$(pwd)/hosts/$HOST_NAME.nix" ]]; then
      (sudo rm -rf /etc/nixos/configuration.nix) && sudo ln -s "$(pwd)/hosts/$HOST_NAME.nix" "/etc/nixos/configuration.nix"
    fi

    nixos-rebuild switch
  fi
}

function main() {
  check_requirements

  case "$HOST_NAME" in
    "gaia")
      install_darwin_based_host 
      ;;
    "demeter")
      install_darwin_based_host
      ;;
    "glaucus")
      install_nixos_based_host
      ;;
    *)
      echo "Host name $HOST_NAME has not been setup yet!"
      exit 1
      ;;
  esac
}

main
