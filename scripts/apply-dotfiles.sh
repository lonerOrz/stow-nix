#!/usr/bin/env bash
set -euo pipefail

user="$1"
dotPath="$2"
targetHome="$3"
backupSuffix="$4"
shift 4
packages=("$@")

if [ ! -d "${dotPath}" ]; then
  echo "stow-nix: Error: dotPath '${dotPath}' does not exist for user ${user}" >&2
  exit 1
fi

echo "stow-nix: Applying stow for user ${user}, packages: ${packages[*]}"
stow --dir="${dotPath}" --target="${targetHome}" --backup-suffix="${backupSuffix}" --stow "${packages[@]}"

echo "stow-nix: Stow completed successfully for ${user}"
