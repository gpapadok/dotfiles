{ config, pkgs, dotfiles, symlink, ...}:

{
  home.packages = with pkgs; [
    emacs
  ];

  home.file = {
    ".emacs.d/gpapadok".source = symlink "${dotfiles}/emacs";
  };

  programs.git.ignores = [
    "*~"
    "\\#*#"
    ".#*"
  ];

  programs.zsh.shellAliases = {
    spacemacs = "emacs --init-directory=~/.spacemacs.d";
  };

  launchd.agents.emacs = {
    enable = true;
    config = {
      ProgramArguments = [
        "${pkgs.emacs}/bin/emacs"
        "--fg-daemon"
      ];
      RunAtLoad = true;
      KeepAlive = true;
      EnvironmentVariables = {
        PATH = "${config.home.homeDirectory}/.nix-profile/bin:/usr/bin:/bin:/usr/sbin:/sbin";
      };
      StandardOutPath = "${config.home.homeDirectory}/Library/Logs/emacs-daemon.log";
      StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/emacs-daemon.log";
    };
  };
}
