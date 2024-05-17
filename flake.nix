{
  description = "Adham's System Flake";

  inputs =
    {
      musnix  = { url = "github:musnix/musnix"; };

      nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
      nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";

      home-manager-unstable.url = "github:nix-community/home-manager";
      home-manager-unstable.inputs.nixpkgs.follows = "nixpkgs-unstable";

      home-manager-stable.url = "github:nix-community/home-manager/release-23.11";
      home-manager-stable.inputs.nixpkgs.follows = "nixpkgs-stable";
    };

  outputs = { nixpkgs-unstable,
              nixpkgs-stable,
              musnix,
              home-manager-unstable,
              home-manager-stable,
              ... }:
    let
      system = "x86_64-linux";
      lib-unstable = nixpkgs-unstable.lib;
      lib-stable = nixpkgs-stable.lib;
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
            home-manager-unstable.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.adham = {
                imports = [ ./main/home.nix ];
              };
            }
          ];
        };


        vm = lib-stable.nixosSystem {
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
