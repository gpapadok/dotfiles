{
  description = "Home manager configuration of gpapadok";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      homeConfigurations."gpapadok" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          ./modules/default.nix
          ./modules/lw.nix
        ];
      };
    };
}
