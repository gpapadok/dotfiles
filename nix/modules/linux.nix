{ config, pkgs, ...}:

{
  home.username = "gpapadok-linux";
  home.homeDirectory = "/home/gpapadok-linux";

  home.packages = with pkgs; [
    wl-clipboard
    nodejs
    php
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
}
