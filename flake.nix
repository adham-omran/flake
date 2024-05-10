{
  description = "Adham's System Flake";

  inputs =
    {
      ## Notes
      ##
      ## The name of the input attribute itself is arbitrary? I can use `stable`
      ## just as I can use `nixpkgs`?
      stable.url = "github:nixos/nixpkgs/nixos-23.11";
      home-manager = {
        url = "github:nix-community/home-manager/release-23.11";
        # inputs.stable.follows = "nixpkgs";
      };
    };

  outputs = { stable, home-manager, ... }:
    let
      system = "x86_64-linux";
      lib = stable.lib;
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
