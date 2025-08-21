{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.stow;

  userOptions =
    { name, ... }:
    {
      options = {
        enable = lib.mkEnableOption "Enable stow for ${name}";

        dotPath = lib.mkOption {
          type = lib.types.str;
          description = ''
            Path to the stow directory, e.g., "~/.dotfiles".
            "~/" will be expanded to the user's home directory.
          '';
          example = "~/.dotfiles";
        };

        backupSuffix = lib.mkOption {
          type = lib.types.str;
          default = "bak";
          description = "Suffix for backup files created by stow.";
        };

        group = lib.mkOption {
          type = lib.types.attrsOf lib.types.bool;
          default = { };
          description = ''
            Attribute set of packages to stow, where the value is a boolean.
            Example: { nvim = true; git = false; }
          '';
          example = "{ nvim = true; }";
        };
      };
    };

  isAnyUserEnabled = lib.any (user: user.enable) (lib.attrValues cfg.users);

in
{
  options.programs.stow = {
    users = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule userOptions);
      default = { };
      description = "Configure stow for each user.";
    };
  };

  config =
    lib.mkMerge (
      lib.mapAttrsToList (
        userName: userCfg:
        let
          userHome = config.users.users.${userName}.home;
          enabledPackages = lib.attrNames (lib.filterAttrs (_: v: v) userCfg.group);
          resolvedDotPath =
            if lib.strings.hasPrefix "~/" userCfg.dotPath then
              userHome + (lib.strings.removePrefix "~/" userCfg.dotPath)
            else
              userCfg.dotPath;
          stowScript = pkgs.writeShellScript "apply-dotfiles-${userName}.sh" (
            builtins.readFile ./scripts/apply-dotfiles.sh
          );
        in
        lib.mkIf userCfg.enable {
          systemd.services."stow-nix-${userName}" = {
            description = "Apply stow dotfiles for user ${userName}";
            serviceConfig = {
              Type = "oneshot";
              User = userName;
              Group = config.users.users.${userName}.group;
              ExecStart = "${stowScript} ${userName} ${resolvedDotPath} ${userHome} ${userCfg.backupSuffix} ${lib.concatStringsSep " " enabledPackages}";
            };
          };

          system.activationScripts."stow-nix-trigger-${userName}" = {
            deps = [ "systemd-units" ];
            text = ''
              ${pkgs.systemd}/bin/systemctl start stow-nix-${userName}.service
            '';
          };
        }
      ) cfg.users
    )
    // {
      environment.systemPackages = lib.mkIf isAnyUserEnabled [ pkgs.stow ];
    };
}
