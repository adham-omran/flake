{
  description = "Adham's System Flake";

  inputs =
    {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
      home-manager = {
      	url = "github:nix-community/home-manager";
      	inputs.nixpkgs.follows = "nixpkgs";
      };
    };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
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
