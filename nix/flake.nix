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
    # TODO(SECURITY): bump crit as soon as a release includes upstream fix 8eb98c7
    # ("sandbox preview content so it can't act as the daemon origin", 2026-11-25).
    # v0.24.0 lets scripts in previewed HTML call the local API, trust repo hooks
    # and run them on Finish. Until then: never `crit preview` untrusted HTML.
    # Pinned to the v0.24.0 commit (security-reviewed 2026-11-27); review the diff before bumping.
    crit = {
      url = "github:tomasz-tomczyk/crit?rev=f28f95bea6aa3a37e1a05ca0293a35a474ce93a3";
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
                  ./modules/symlink.nix
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
            ./modules/symlink.nix
            ./modules/default.nix
          ];
        };

        nixosModules.parnitha = {
          imports = [
            ./hosts/parnitha/configuration.nix
          ];
        };
      };
}
