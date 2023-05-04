{
  description = "Adham's System Flake";

  inputs =
    {
      nur.url = github:nix-community/NUR;
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
      home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      hyprland.url = "github:hyprwm/Hyprland";
    };

  outputs = { self, nixpkgs, home-manager, hyprland, nur, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      lib = nixpkgs.lib;
    in {
      nixosConfigurations = {
        nixos = lib.nixosSystem {
          inherit system;
          modules = [
            ./configuration.nix
            # NUR module, TODO make it work.
            nur.nixosModules.nur
            ./nur/config.nur

            # home-manager module
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.adham = {
                imports = [ ./home.nix ];
              };
            }
          ];
        };
      };
    };
}
