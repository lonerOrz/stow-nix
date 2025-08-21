# stow-nix

Declarative dotfiles management using GNU Stow and Nix/NixOS, with a robust systemd-based architecture.

## 📦 Features

- **Declarative & Automated**: Integrates `stow` into NixOS's declarative model. `stow` is installed automatically.
- **Multi-User Support**: Configure different dotfiles for different users on the same system.
- **Flexible Package Toggling**: Easily enable or disable dotfile packages using boolean flags.
- **Robust Logging & Debugging**: Each user's stow operation runs as a dedicated `systemd` service, providing excellent logging via `journalctl`.
- **Clean Separation**: Separates the NixOS module logic from the operational shell script.
- **No Manual Steps**: Dotfiles are applied automatically and reliably during `nixos-rebuild switch`.

## ⚙️ Usage

### 1. Add to your flake inputs

```nix
# flake.nix
inputs.stow-nix.url = "github:lonerOrz/stow-nix";
```

### 2. Import and configure the module

Import the module into your NixOS configuration. Define the settings for each user under `programs.stow.users`. The module will automatically create and trigger a `systemd` service for each enabled user.

```nix
# configuration.nix
{
  imports = [ inputs.stow-nix.nixosModules.default ];

  programs.stow = {
    users = {
      # Replace 'your-username' with the actual username.
      # This user must exist in your NixOS configuration.
      "your-username" = {
        enable = true;
        dotPath = "~/.dotfiles"; # Path to your stow directory. '~' is expanded automatically.
        backupSuffix = "bak";   # Optional: suffix for backups.
        group = {
          # List of packages to manage.
          # 'true' means the package will be stowed.
          nvim.enable = true;
          bash.enable = true;

          # 'false' means the package will be ignored.
          git.enable = false;
        };
      };

      # You can add another user here.
      # "another-user" = {
      #   enable = true;
      #   dotPath = "/home/another-user/dots"; # Absolute paths also work.
      #   group = { zsh = true; };
      # };
    };
  };
}
```

### 3. Rebuild your system

Your dotfiles will be automatically applied for all enabled users via their respective `systemd` services.

```bash
sudo nixos-rebuild switch
```

### 4. Troubleshooting

Because each operation runs as a service, you can easily check its status and logs using `journalctl`.

```bash
# Check the status of the service for a specific user
_sudo systemctl status stow-nix-your-username.service_

# View the detailed logs for a specific user
_sudo journalctl -u stow-nix-your-username.service_
```

## 🧪 Development Shell

For formatting and testing:

```bash
nix develop
```

## 📝 TODO

- [ ] Improve argument parsing reliability.
  - [ ] Add support for package names containing spaces.
- [ ] Enhance symlinking reliability (perhaps with a Python-based implementation).
- [ ] Implement a test suite to verify module behavior.

## License

MIT