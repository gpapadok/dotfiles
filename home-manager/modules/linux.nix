{ config, pkgs, ...}:

{
  home.username = "gpapadok-linux";
  home.homeDirectory = "/home/gpapadok-linux";

  home.packages = [

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
}
