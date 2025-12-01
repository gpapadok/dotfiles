{ config, pkgs, ... }:

{
  home.username = "gpapadok";
  home.homeDirectory = "/home/gpapadok";

  home.stateVersion = "25.05"; # You should not manually update this value

  fonts.fontconfig.enable = true;

  home.packages = [
    pkgs.neovim
    pkgs.htop
    pkgs.ripgrep
    pkgs.tmux
    pkgs.tree
    pkgs.fd

    pkgs.nerd-fonts.roboto-mono
  ];

  home.file = {
    ".tmux.conf".source = ../dotfiles/tmux.conf;

    # Alternatively
    # ".grade/grade.properties".text = ''
    #   org.grade.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.home-manager.enable = true;
}
