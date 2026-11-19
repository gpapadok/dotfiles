{
  description = "Home manager configuration of gpapadok";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    crit = {
      url = "github:tomasz-tomczyk/crit";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, nix-darwin, home-manager, crit, ... }:
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
            extraSpecialArgs = { inherit crit; };
          };
    in
      {
        darwinConfigurations."gpapadok" = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            ./modules/darwin.nix
            home-manager.darwinModules.home-manager
            {
              users.users.gpapadok.home = "/Users/gpapadok";
              home-manager = {
                useGlobalPkgs = true;
                extraSpecialArgs = { inherit crit; };
                users.gpapadok.imports = [
                  ./modules/mac.nix
                  ./modules/clojure.nix
                  ./modules/emacs.nix
                  ./modules/git.nix
                  ./modules/default.nix
                ];
              };
            }
          ];
        };

        homeConfigurations = {
          "gpapadok-linux" = homeManagerConfiguration "x86_64-linux" [
            ./modules/linux.nix
            ./modules/clean-downloads.nix
            ./modules/git.nix
            ./modules/default.nix
          ];
        };
      };
}
