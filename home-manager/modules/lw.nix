{ config, pkgs, ... }:

{
  home.packages = [
    pkgs.hello
    pkgs.mongosh
    pkgs.vi-mongo
    pkgs.nodejs
    pkgs.rclone
    pkgs.k9s
    pkgs.kubectx
    pkgs.kubectl
    pkgs.go

    (pkgs.writeShellScriptBin "error-log-remove-activity-ids" ''
      awk -F';' '{print($1","$2","$NF)}' $1
    '')
  ];

  home.file = {
    ".lw_aliases".source = ../dotfiles/lw_aliases;
  };

  programs.git = {
    enable = true;

    settings = {
      user = {
        email = "george.papadokostakis@learnworlds.com";
        username = "Giorgos Papadokostakis";
      };

      alias = {
        retag = "!f() { git tag -f -a \"$1\" -m \"$1\" && git push origin \"$1\" -f; }; f";
        deltag = "!f() { git tag -d \"$1\" && git push --delete origin \"$1\"; }; f";
      };

      core.editor = "nvim";
    };
  };
}
