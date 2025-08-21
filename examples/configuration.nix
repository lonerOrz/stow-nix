{
  # Example configuration for your stow-nix module.
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