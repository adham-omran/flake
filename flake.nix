{
  description = "Adham's System Flake";

  inputs =
    {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
      stable.url = "github:nixos/nixpkgs/nixos-23.11";
      musnix  = { url = "github:musnix/musnix"; };
      home-manager.url = "github:nix-community/home-manager";
      home-manager.inputs.nixpkgs.follows = "nixpkgs";
    };

  outputs = { nixpkgs, stable, musnix, home-manager, ... }:
    let
      system = "x86_64-linux";
      lib-unstable = nixpkgs.lib;
      lib-stable = stable.lib;
    in {
      nixosConfigurations = {
        t480 = lib-stable.nixosSystem {
          inherit system;
          modules = [
            ./t480/configuration.nix
          ];
        };

        main = lib-unstable.nixosSystem {
          inherit system;
          modules = [
            musnix.nixosModules.musnix
            ./main/configuration.nix
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.adham = {
                imports = [ ./main/home.nix ];
              };
            }
          ];
        };


        vm = lib-unstable.nixosSystem {
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

# Local Variables:
# jinx-local-words: "Adham's github linux musnix nixos nixpkgs"
# End:
