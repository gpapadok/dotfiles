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
      homeManagerConfiguration =
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
          modules:
          home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            inherit modules;
          };
    in
    {
      homeConfigurations = {
        "lwgpapadok" = homeManagerConfiguration "x86_64-linux" [
          ./modules/lw.nix
          ./modules/default.nix
        ];

        "gpapadok" = homeManagerConfiguration "aarch64-darwin" [
          ./modules/mac.nix
          ./modules/default.nix
        ];

        "gpapadok-linux" = homeManagerConfiguration "x86_64-linux" [
          ./modules/linux.nix
          ./modules/default.nix
        ];
      };
    };
}
