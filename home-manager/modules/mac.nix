{ config, pkgs, ...}:

{
  home.username = "gpapadok";
  home.homeDirectory = "/Users/gpapadok";

  home.packages = [
    pkgs.clojure
    pkgs.leiningen
    pkgs.emacs
  ];

  programs.git = {
    enable = true;

    settings = {
      user = {
        email = "giorgos.papadokostakis@proton.me";
        username = "gpapadok";
      };

      core.editor = "nvim";
    };
  };

  programs.zsh.shellAliases = {
    spacemacs = "emacs --init-directory=~/.spacemacs.d";
  };

  launchd.agents = {
    emacs = {
      enable = true;
      config = {
        ProgramArguments = [
          "${pkgs.emacs}/bin/emacs"
          "--fg-daemon"
        ];
        RunAtLoad = true;
        KeepAlive = true;
        StandardOutPath = "${config.home.homeDirectory}/Library/Logs/emacs-daemon.log";
        StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/emacs-daemon.log";
      };
    };

    downloads-cleanup = {
      enable = true;
      config = {
        ProgramArguments = [
          "${pkgs.writeShellScript "downloads-cleanup" ''
            find "${config.home.homeDirectory}/Downloads" -mindepth 1 -mtime +30 -delete
          ''}"
        ];
        StartCalendarInterval = [
          { Weekday = 0; Hour = 9; Minute = 15; }
        ];
        StandardOutPath = "${config.home.homeDirectory}/Library/Logs/downloads-cleanup.log";
        StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/downloads-cleanup.log";
      };
    };

    brew-update = {
      enable = true;
      config = {
        ProgramArguments = [
          "${pkgs.writeShellScript "brew-update" ''
            export PATH="/opt/homebrew/bin:$PATH"
            brew update
            brew upgrade
            brew cleanup
          ''}"
        ];
        StartCalendarInterval = [
          { Weekday = 0; Hour = 9; Minute = 0; }
        ];
        StandardOutPath = "${config.home.homeDirectory}/Library/Logs/brew-update.log";
        StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/brew-update.log";
      };
    };
  };
}
