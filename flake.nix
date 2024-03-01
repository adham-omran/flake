{
  description = "Adham's System Flake";

  inputs =
    {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    };

  outputs = { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
    in {
      nixosConfigurations = {
        t480 = lib.nixosSystem {
          inherit system;
          modules = [
            ./t480/configuration.nix
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
          ];
        };
      };
    };
}
