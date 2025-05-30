---
# stow-nix

Declarative dotfiles management using GNU Stow and Nix/NixOS.

## 📦 Features

- Declarative configuration of dotfiles
- Based on GNU Stow
- NixOS module with system-level integration
- Supports overriding shell script
- nix run support

## ⚙️ Usage

### 1. Add to your flake inputs

```nix
inputs.stow-nix.url = "github:yourusername/stow-nix";
````

### 2. Import the module in your NixOS configuration

```nix
{
  imports = [ inputs.stow-nix.nixosModules.default ];

  programs.stow = {
    enable = true;
    dotfilesDir = "/home/youruser/dotfiles";
    packages = [ "nvim" "bash" ];
  };
}
```

### 3. Rebuild your system

```bash
sudo nixos-rebuild switch
```

### 4. Apply your dotfiles

```bash
sudo /etc/apply-dotfiles.sh
```

### Optional: Override the apply script

```nix
programs.stow.dotfilesScript = ./my-custom-script.sh;
```

The script will be installed as `/etc/apply-dotfiles.sh`.

## 🧪 Development Shell

For formatting and testing:

```bash
nix develop
```

Includes:

* stow
* nixpkgs-fmt
* nixd
* nil

## License

MIT
