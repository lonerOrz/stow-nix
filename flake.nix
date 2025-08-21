{
  description = "stow-nix: Declarative dotfiles management using GNU Stow in NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
    in {
      packages.stow = pkgs.stow;

      nixosModules.default = import ./modules/stow-nix.nix {inherit pkgs;};
      devShells.default = import ./devShell.nix {inherit pkgs;};
    });
}
