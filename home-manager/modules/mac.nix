{ config, pkgs, ...}:

{
  home.username = "gpapadok";
  home.homeDirectory = "/Users/gpapadok";

  home.packages = [
    pkgs.clojure
    pkgs.leiningen
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

  launchd.agents.brew-update = {
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
}
