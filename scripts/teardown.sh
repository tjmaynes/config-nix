#!/bin/bash

set -e

function main() {
  nix-env -e '.*'

  rm -rf $HOME/.nix-*
  rm -rf $HOME/.config/nixpkgs
  rm -rf $HOME/.cache/nix
  rm -rf $HOME/.nixpkgs

  if [ -L $HOME/Applications ]; then
    rm $HOME/Applications
  fi

  sudo rm -rf /etc/nix /nix

  [ ! -f /Library/LaunchDaemons/org.nixos.nix-daemon.plist ] && exit 0

  if [ -f /Library/LaunchDaemons/org.nixos.nix-daemon.plist ]; then
    sudo launchctl unload /Library/LaunchDaemons/org.nixos.nix-daemon.plist
    sudo rm /Library/LaunchDaemons/org.nixos.nix-daemon.plist
  fi

  if [ -f /etc/profile.backup-before-nix ]; then
    sudo mv /etc/profile.backup-before-nix /etc/profile
  fi

  if [ -f /etc/bashrc.backup-before-nix ]; then
    sudo mv /etc/bashrc.backup-before-nix /etc/bashrc
  fi

  if [ -f /etc/zshrc.backup-before-nix ]; then
    sudo mv /etc/zshrc.backup-before-nix /etc/zshrc
  fi

  USERS=$(sudo dscl . list /Users | grep nixbld)

  for USER in $USERS; do
    sudo /usr/bin/dscl . -delete "/Users/$USER"
    sudo /usr/bin/dscl . -delete /Groups/staff GroupMembership $USER;
  done

  sudo /usr/bin/dscl . -delete "/Groups/nixbld"
  sudo rm -rf /var/root/.nix-*
  sudo rm -rf /var/root/.cache/nix

  # useful for finding hanging links
  $ find . -type l -maxdepth 5 ! -exec test -e {} \; -print 2>/dev/null | xargs -I {} sh -c 'file -b {} | grep nix && echo {}'
}

main
