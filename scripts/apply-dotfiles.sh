#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
TARGET_DIR="${TARGET_DIR:-$HOME}"
PACKAGES=(${STOW_PACKAGES:-})

if [ ! -d "$DOTFILES_DIR" ]; then
  echo "Error: DOTFILES_DIR '$DOTFILES_DIR' does not exist."
  exit 1
fi

if [ "${#PACKAGES[@]}" -eq 0 ]; then
  echo "Error: No STOW_PACKAGES provided."
  exit 1
fi

exec stow --dir="$DOTFILES_DIR" --target="$TARGET_DIR" "${PACKAGES[@]}"
