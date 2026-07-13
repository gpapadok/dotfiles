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
}
