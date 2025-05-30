{
  programs.stow = {
    enable = true;
    dotfilesDir = "/home/youruser/dotfiles";
    packages = ["nvim" "bash" "git"];
    installStow = true;

    # optional:
    # dotfilesScript = /home/youruser/my-apply-script.sh;
  };
}
