{
  description = "Adham's System Flake";

  inputs =
    {
      home-manager = {
        url = "github:nix-community/home-manager/release-23.11";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    };

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
    in {
      nixosConfigurations = {
        t480 = lib.nixosSystem {
          inherit system;
          modules = [
            ./t480/configuration.nix
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
            }
          ];
        };

        main = lib.nixosSystem {
          inherit system;
          modules = [
            ./main/configuration.nix
          ];
        };


        vm = lib.nixosSystem {
          inherit system;
          modules = [
            ./vm/configuration.nix
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.adham = {
                imports = [ ./vm/home.nix ];
              };
            }
          ];
        };
      };
    };
}
