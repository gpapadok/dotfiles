{ config, pkgs, ...}:

{
  home.username = "gpapadok";
  home.homeDirectory = "/Users/gpapadok";

  home.packages = with pkgs; [
    entr
    ispell
    direnv
    cloudflared
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

    ignores = [
      ".DS_Store"
    ];
  };

  # brew and orbstack normally append these to .zprofile themselves;
  # since home-manager manages .zprofile, they're folded in here.
  programs.zsh.profileExtra = ''
    eval "$(/opt/homebrew/bin/brew shellenv)"

    # Added by OrbStack: command-line tools and integration
    # This won't be added again if you remove it.
    source ~/.orbstack/shell/init.zsh 2>/dev/null || :
  '';

  programs.direnv.enable = true;

  launchd.agents = {
    cleanup-downloads = {
      enable = true;
      config = {
        ProgramArguments = [
          "/usr/bin/find" "${config.home.homeDirectory}/Downloads"
          "-mindepth" "1" "-maxdepth" "1" "-mtime" "+30"
          "-exec" "/bin/mv" "-n" "{}" "${config.home.homeDirectory}/.Trash/" ";"
        ];
        StartCalendarInterval = [
          { Weekday = 0; Hour = 9; Minute = 15; }
        ];
        StandardOutPath = "${config.home.homeDirectory}/Library/Logs/cleanup-downloads.log";
        StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/cleanup-downloads.log";
      };
    };

    brew-maintenance = {
      enable = true;
      config = {
        ProgramArguments = [
          "${pkgs.writeShellScript "brew-maintenance" ''
            export PATH="/opt/homebrew/bin:$PATH"
            brew update
            brew upgrade
            brew cleanup
          ''}"
        ];
        StartCalendarInterval = [
          { Weekday = 0; Hour = 9; Minute = 0; }
        ];
        StandardOutPath = "${config.home.homeDirectory}/Library/Logs/brew-maintenance.log";
        StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/brew-maintenance.log";
      };
    };
  };
}
