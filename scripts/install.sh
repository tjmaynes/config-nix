#!/bin/bash

set -eo pipefail

HOST_NAME=$1
HOST_TYPE=$2
HOST_USERNAME=$3
NIX_PARTITION=${4:-40}

function check_requirements() {
  if [[ -z "$HOST_NAME" ]]; then
    echo "Please provide a 'HOST_NAME' arg"
    exit 1
  elif [[ -z "$HOST_TYPE" ]]; then
    echo "Please provide a 'HOST_TYPE' arg"
    exit 1
  elif [[ -z "$HOST_USERNAME" ]]; then
    echo "Please provide a 'HOST_USERNAME' arg"
    exit 1
  fi
}

function backup_etc_dir() {
  if [[ -f "/etc/nix/nix.conf" ]]; then
    sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.backup
  fi

  if [[ -f "/etc/shells" ]]; then
    sudo mv /etc/shells /etc/shells.backup
  fi
}

function install_nixpkgs() {
  if [[ -z "$(nix-channel --list | grep 'nixpkgs')" ]]; then
    nix-channel --add "https://nixos.org/channels/nixpkgs-unstable" nixpkgs
    nix-channel --update
  fi
}

function install_home_manager() {
  if [[ -z "$(nix-channel --list | grep 'home-manager')" ]]; then
    nix-channel --add "https://github.com/nix-community/home-manager/archive/master.tar.gz" home-manager
    nix-channel --update
  fi
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
  export NIX_PATH=darwin-config=$HOME/.nixpkgs/darwin-configuration.nix${NIX_PATH:+:}$NIX_PATH
  export NIX_PATH=nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixpkgs${NIX_PATH:+:}$NIX_PATH

  if [[ -z "$(command -v git)" ]]; then
    xcode-select --install
  fi

  if [[ "$(uname -m)" = "arm64" ]]; then
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

  backup_etc_dir

  install_nixpkgs
  install_home_manager
  install_nix_darwin
}

function install_linux_based_host() {
  if [[ "$OSTYPE" != "linux-gnu"* ]]; then
    echo "Please run this script on a Linux-based machine"
    exit 1
  elif [[ -z "$(command -v curl)" ]]; then
    echo "Please install 'curl' before running this script"
    exit 1
  fi

  if [[ ! -d "/nix" ]]; then
    sudo mkdir /nix
    sudo chown "$HOST_USERNAME" /nix
  fi

  export PATH=/usr/sbin:$PATH
  export NIX_PATH=$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH
  export NIX_PATH=nixpkgs=/nix/var/nix/profiles/per-user/$HOST_USERNAME/channels/nixpkgs${NIX_PATH:+:}$NIX_PATH
  export NIX_PATH=home-manager=/nix/var/nix/profiles/per-user/$HOST_USERNAME/channels/home-manager${NIX_PATH:+:}$NIX_PATH

  if [[ -z "$(command -v nix)" ]]; then
    /bin/sh -c "$(curl -fsSL https://nixos.org/nix/install)" --daemon
  fi

  . $HOME/.nix-profile/etc/profile.d/nix.sh

  backup_etc_dir

  install_nixpkgs
  install_home_manager

  nix-channel --update

  if [[ ! "$(readlink $HOME/.config/nixpkgs/home.nix)" -ef "$(pwd)/hosts/$HOST_NAME.nix" ]]; then
    rm -rf "$HOME/.config/nixpkgs"
    (mkdir -p "$HOME/.config/nixpkgs" || true) && ln -s "$(pwd)/hosts/$HOST_NAME.nix" "$HOME/.config/nixpkgs/home.nix"
  fi

  home-manager switch
}

function install_nixos_based_host() {
  if [[ "$OSTYPE" != "linux-gnu"* ]]; then
    echo "Please run this script on a Linux-based machine"
    exit 1
  fi

  if [[ -n "$(parted -s /dev/sda print | grep 'root')" ]]; then
    echo "Already created root partition!"
  else
    echo "Please create 'root' partition using parted before running this script"
    exit 1
  fi

  if [[ -n "$(parted -s /dev/sda print | grep 'BOOT')" ]]; then
    echo "Already created BOOT partition!"
  else
    echo "Please create 'BOOT' partition using parted before running this script"
    exit 1
  fi

  if [[ -n "$(parted -s /dev/sda print | grep 'swap')" ]]; then
    echo "Already created swap partition!"
  else
    echo "Please create 'swap' partition using parted before running this script"
    exit 1
  fi

  if [[ -n "$(ls -l /dev/disk/by-label | grep 'sda1' | grep 'root')" ]]; then
    echo "Already created root ext4 filesystem on /dev/sda1..."
  else
    echo "Creating root label for /dev/sda1..."
    mkfs.ext4 -L root /dev/sda1
  fi

  if [[ -n "$(mount | awk '$3' | grep '/dev/sda1')" ]]; then
    echo "Already mounted root to /mnt..."
  else
    echo "Setting root mount to /mnt"
    mount /dev/disk/by-label/root /mnt
  fi

  if [[ -n "$(ls -l /dev/disk/by-label | grep 'sda3' | grep 'BOOT')" ]]; then
    echo "Already created BOOT fat32 filesystem on /dev/sda3..."
  else
    echo "Creating boot label for /dev/sda3..."
    mkfs.fat -F 32 -n BOOT /dev/sda3      # (for UEFI systems only)
  fi

  if [[ -d "/mnt/BOOT" ]]; then
    echo "Already created /mnt/BOOT directory..."
  else
    mkdir -p /mnt/BOOT                    # (for UEFI systems only)
  fi

  if [[ -n "$(mount | awk '$3' | grep '/dev/sda3')" ]]; then
    echo "Already set BOOT mount to /mnt/BOOT..."
  else
    echo "Setting BOOT mount to /mnt/BOOT"
    mount /dev/disk/by-label/BOOT /mnt/BOOT
  fi

  # if [[ -z "$(ls -l /dev/disk/by-label | grep 'sda2' | grep 'swap')" ]]; then
  #   echo "Creating swap mount..."
  #   mkswap -L swap /dev/sda2
  # fi

  # if [[ "$(swapon -s | wc -l)" -lt 1 ]]; then
  #   echo "Setting swapon to swap mount..."
  #   swapon -L swap /dev/sda2
  # fi

  if [[ -f "/mnt/etc/nixos/hardware-configuration.nix" ]]; then
    rm -rf /mnt/etc/nixos/hardware-configuration.nix
  fi

  nixos-generate-config --root /mnt

  if [[ ! -f "$(pwd)/hosts/hardware-configuration.nix" ]]; then
    cp -f "/mnt/etc/nixos/hardware-configuration.nix" "$(pwd)/hosts/hardware-configuration.nix"
  fi

  if [[ ! "/mnt/etc/nixos/configuration.nix" -ef "$(pwd)/hosts/$HOST_NAME.nix" ]]; then
    (rm -rf /mnt/etc/nixos/configuration.nix) && ln -s "$(pwd)/hosts/$HOST_NAME.nix" "/mnt/etc/nixos/configuration.nix"
  fi

  install_nixpkgs
  install_home_manager

  nixos-install

  if [[ "whoami" -eq "root" ]]; then
    if ! id "$HOST_USERNAME" &>/dev/null; then
      useradd -c '"$HOST_USERNAME"' -m "$HOST_USERNAME"
      passwd "$HOST_USERNAME"
    fi
  fi

  reboot
}

function install_arch_based_host() {
  if [[ "$(uname -r)" != "ARCH"* ]]; then
    echo "Please run this script on a Arch linux-based machine"
    exit 1
  fi

  if [[ -z "$(command -v nix)" ]]; then
    /bin/sh -c "$(curl -fsSL https://nixos.org/nix/install)" --daemon
  fi

  backup_etc_dir

  install_nixpkgs
  install_home_manager
}

function main() {
  check_requirements

  if [[ -n "$(command -v git)" ]]; then 
    git submodule update --init --recursive
  fi

  case "$HOST_TYPE" in
    "darwin")
      install_darwin_based_host 
      ;;
    "linux")
      install_linux_based_host
      ;;
    "nixos")
      install_nixos_based_host
      ;;
    "arch")
      install_arch_based_host
      ;;
    *)
      echo "Host type $HOST_TYPE has not been setup yet!"
      exit 1
      ;;
  esac
}

main
