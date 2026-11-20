{ ... }:

{
  nix = {
    enable = true;

    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      always-allow-substitutes = true;
      max-jobs = "auto";
    };

    gc = {
      automatic = true;
      interval = { Weekday = 1; Hour = 0; Minute = 0; };
      options = "--delete-older-than 30d";
    };

    optimise.automatic = true;
  };

  system.primaryUser = "gpapadok";
  system.stateVersion = 6;
}
