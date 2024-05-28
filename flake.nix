{
  description = "Adham's System Flake";

  inputs =
    {
      musnix  = { url = "github:musnix/musnix"; };

      nixpkgs-24-05.url = "github:nixos/nixpkgs/nixos-24.05";
      nixpkgs-23-11.url =   "https://github.com/NixOS/nixpkgs/archive/nixos-23.11.tar.gz";

      home-manager-unstable.url = "github:nix-community/home-manager/release-24.05";
      home-manager-unstable.inputs.nixpkgs.follows = "nixpkgs-24-05";

      home-manager-stable.url = "github:nix-community/home-manager/release-23.11";
      home-manager-stable.inputs.nixpkgs.follows = "nixpkgs-23-11";
    };

  outputs = { nixpkgs-24-05,
              nixpkgs-23-11,
              musnix,
              home-manager-unstable,
              home-manager-stable,
              ... }:
    let
      system = "x86_64-linux";
      lib-24-05 = nixpkgs-24-05.lib;
      lib-23-11 = nixpkgs-23-11.lib;
    in {
      nixosConfigurations = {

        t480 = lib-23-11.nixosSystem {
          inherit system;
          modules = [
            ./t480/configuration.nix
          ];
        };

        main = lib-24-05.nixosSystem {
          inherit system;
          modules = [
            musnix.nixosModules.musnix
            ./main/configuration.nix
            home-manager-unstable.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.adham = {
                imports = [ ./main/home.nix ];
              };
            }
          ];
        };


        vm = lib-23-11.nixosSystem {
          inherit system;
          modules = [
            ./vm/configuration.nix
            home-manager-stable.nixosModules.home-manager {
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
