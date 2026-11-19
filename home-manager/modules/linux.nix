{ config, pkgs, ...}:

{
  home.username = "gpapadok-linux";
  home.homeDirectory = "/home/gpapadok-linux";

  home.packages = with pkgs; [
    wl-clipboard
    nodejs
    php
  ];
}
