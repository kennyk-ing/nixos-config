{
  description = "Kenny's NixOS Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    my-nixvim.url = "github:kennyk-ing/nixvim-flake";
    my-nixvim.inputs.nixpkgs.follows = "nixpkgs-unstable";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { 
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    agenix,
    ... }@inputs:
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
            agenix.nixosModules.default
            ./hosts/kirby
            home-manager.nixosModules.home-manager
          ];
        };
      };
    };
}
