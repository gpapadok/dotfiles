{ config, pkgs, crit, ... }:

{
  home.stateVersion = "25.05"; # You should not manually update this value

  fonts.fontconfig.enable = true;

  home = {
    packages = with pkgs; [
      neovim
      tree-sitter
      htop
      ripgrep
      tmux
      tree
      fd
      tree-sitter
      zsh
      oh-my-zsh
      postgresql_17_jit
      rainfrog
      gh
      crit.packages.${stdenv.hostPlatform.system}.default
      delta

      # TUIs
      btop
      lazygit
      lazydocker
      fzf
      yazi
      posting
      ncdu
      leaf-markdown-viewer

      # networking
      whois

      # fonts
      nerd-fonts.roboto-mono
      inter
      jetbrains-mono
    ];

    sessionVariables = {
      EDITOR = "nvim";
    };

    sessionPath = [
      "${config.home.homeDirectory}/.local/bin"
      "${config.home.homeDirectory}/bin"
    ];
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

        dc = "docker compose";
        dockps = "docker ps --format \"{{.ID}} {{.Names}}\"";

        aws = "docker run --rm -it -v ~/.aws:/root/.aws amazon/aws-cli";
        stripe = "docker run --rm -it -v ~/.config/stripe:/root/.config/stripe stripe/stripe-cli:latest";

        df = "df -h";
        du = "du -hs";
      };
    };

    git.ignores = [
      # AI
      "**/.claude/worktrees/"
      "**/.claude/projects/"
      "**/.claude/settings.local.json"
      "CLAUDE.local.md"
      "graphify-out/"
      ".archify/"

      "gpapadok-notes"
      ".k9s/"
      "lazygit"
    ];
  };
}
