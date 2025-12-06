{ config, pkgs, ... }:

{
  home.username = "gpapadok";
  home.homeDirectory = "/Users/gpapadok";

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
    pkgs.postgresql_17_jit
    pkgs.rainfrog

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
          "sh-autosuggestions"
          "you-should-use"
        ];
      };

      shellAliases = {
        hms = "home-manager switch";

        dc_ = "docker compose";
        dcup = "docker compose up";
        dcdown = "docker compose down";
        dockps = "docker ps --format \"{{.ID}} {{.Names}}\"";
        dcbuild = "docker compose build";

        stripe = "docker run --rm -it -v ~/.config/stripe:/root/.config/stripe stripe/stripe-cli:latest";

        df = "df -h";
        du = "du -hs";
      };
    };
  };
}
