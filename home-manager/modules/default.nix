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
    pkgs.zsh
    pkgs.oh-my-zsh

    # networking
    pkgs.whois

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

  programs = {
    home-manager.enable = true;

    tmux = {
      enable = true;

      shell = "${pkgs.zsh}/bin/zsh";
    };

    zsh = {
      enable = true;

      oh-my-zsh = {
        enable = true;

        theme = "robbyrussell";
        plugins = [
          "git"
        ];
      };

      shellAliases = {
        hms = "home-manager switch";
      };
    };
  };
}
