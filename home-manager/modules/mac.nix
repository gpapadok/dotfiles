{ config, pkgs, ...}:

{
  home.username = "gpapadok";
  home.homeDirectory = "/Users/gpapadok";

  home.packages = with pkgs; [
    entr
    ispell
    direnv
    cloudflared

    (pkgs.writeShellScriptBin "clean-downloads" ''
      dir="$HOME/Downloads"
      find_old() { /usr/bin/find "$dir" -mindepth 1 -maxdepth 1 -mtime +30 -print "$@"; }
      if [ "$1" = "--dry" ]; then
        find_old
      else
        find_old -exec /bin/mv -n {} "$HOME/.Trash/" \;
      fi
    '')
  ];

  programs.git.ignores = [
    ".DS_Store"
  ];

  # brew and orbstack normally append these to .zprofile themselves;
  # since home-manager manages .zprofile, they're folded in here.
  programs.zsh.profileExtra = ''
    eval "$(/opt/homebrew/bin/brew shellenv)"

    # Added by OrbStack: command-line tools and integration
    # This won't be added again if you remove it.
    source ~/.orbstack/shell/init.zsh 2>/dev/null || :
  '';

  programs.direnv.enable = true;

  launchd.agents.brew-maintenance = {
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
}
