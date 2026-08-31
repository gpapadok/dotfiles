{ config, pkgs, ... }:

{
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
    pkgs.gh
    pkgs.beads

    # networking
    pkgs.whois

    pkgs.nerd-fonts.roboto-mono
  ];

  home.file = {
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
      terminal = "xterm-256color";
      keyMode = "emacs";
      shortcut = "o";

      extraConfig = ''
        bind r source-file ~/.config/tmux/tmux.conf \; display-message "tmux.conf reloaded."

        set -s set-clipboard on

        # colors
        set -g status-style 'bg=#008b8b fg=#f5fffa'
        set -g status-left-length 32
      '';
    };

    zsh = {
      enable = true;

      # Nix store paths on fpath are root-owned and immutable.
      # oh-my-zsh can flag them insecure if home-manager was setup
      # for another user first.
      envExtra = ''
        export ZSH_DISABLE_COMPFIX="true"
      '';

      # brew and orbstack normally append these to .zprofile themselves;
      # since home-manager manages .zprofile, they're folded in here.
      profileExtra = ''
        eval "$(/opt/homebrew/bin/brew shellenv)"

        # Added by OrbStack: command-line tools and integration
        # This won't be added again if you remove it.
        source ~/.orbstack/shell/init.zsh 2>/dev/null || :
      '';

      plugins = [
        {
          name = "zsh-autosuggestions";
          file = "zsh-autosuggestions.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-autosuggestions";
            rev = "v0.7.1";
            sha256 = "sha256-vpTyYq9ZgfgdDsWzjxVAE7FZH4MALMNZIFyEOBLm5Qo=";
          };
        }
        {
          name = "you-should-use";
          file = "you-should-use.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "MichaelAquilina";
            repo = "zsh-you-should-use";
            rev = "master";
            sha256 = "sha256-1ojmr9+Wg5+X5Dip4sKjP4IKKACMncPQDZ8RtYQSQ80=";
          };
        }
      ];

      oh-my-zsh = {
        enable = true;

        theme = "robbyrussell";
        plugins = [
          "git"
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

        aws = "docker run --rm -it -v ~/.aws:/root/.aws amazon/aws-cli";
      };

      initContent = ''
        if [[ -d /home/$USER/bin ]]; then
          export PATH=/home/$USER/bin:$PATH
        fi
      '';
    };
  };

  programs.git.ignores = [
    # AI
    "**/.claude/worktrees/"
    "**/.claude/settings.local.json"
    # Emacs
    "*~"
    "\#*#"
    ".#*"
  ];
}
