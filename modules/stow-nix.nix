{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.programs.stow;
  scriptFile =
    if cfg.dotfilesScript != null
    then cfg.dotfilesScript
    else
      pkgs.writeShellScript "apply-dotfiles.sh" ''
        #!/usr/bin/env bash
        set -euo pipefail

        DOTFILES_DIR="${cfg.dotfilesDir}"
        TARGET_DIR="$HOME"

        if [ ! -d "$DOTFILES_DIR" ]; then
          echo "Error: dotfilesDir '$DOTFILES_DIR' does not exist."
          exit 1
        fi

        ${pkgs.stow}/bin/stow \
          --dir="$DOTFILES_DIR" \
          --target="$TARGET_DIR" \
          ${lib.concatStringsSep " " cfg.packages}
      '';
in {
  options.programs.stow = {
    enable = lib.mkEnableOption "Enable stow-nix dotfiles management";

    dotfilesDir = lib.mkOption {
      type = lib.types.path;
      description = "Absolute path to the dotfiles directory";
    };

    packages = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "List of stow package directories inside dotfilesDir";
    };

    dotfilesScript = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Optional custom script for dotfiles application";
    };

    installStow = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to install GNU Stow system-wide";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = lib.optional cfg.installStow pkgs.stow;

    environment.etc."apply-dotfiles.sh".source = scriptFile;

    systemd.tmpfiles.rules = ["L+ /etc/apply-dotfiles.sh 0755 root root -"];
  };
}
