{
  description = "Kenny's NixOS Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    my-nixvim ={ 
      url = "github:kennyk-ing/nixvim-flake";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
      };
    in
    {
      nixosConfigurations = {
        kirby = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs pkgs-unstable; };
          modules = [
            { nixpkgs.hostPlatform = "x86_64-linux"; }
            ./hosts/kirby
            home-manager.nixosModules.home-manager
          ];
        };
      };
    };
}
