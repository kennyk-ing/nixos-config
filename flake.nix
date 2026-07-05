{
  description = "Kenny's NixOS Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    my-nixvim.url = "github:kennyk-ing/nixvim-flake";
    my-nixvim.inputs.nixpkgs.follows = "nixpkgs-unstable";

    privateData = {
      url = "git+ssh://git@github.com/kennyk-ing/nixos-private.git";
      flake = false;
    };

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    agenix,
    disko,
    ... }@inputs:
    let
      system = "x86_64-linux";

      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };

      sharedModules = [
        { nixpkgs.hostPlatform = "x86_64-linux"; }
        agenix.nixosModules.default
        disko.nixosModules.default
        ./modules
        ./users
        home-manager.nixosModules.home-manager
        {
          home-manager.extraSpecialArgs = { inherit inputs pkgs-unstable; };
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
      ];

      mkHost = hostName: nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs pkgs-unstable; };
        modules = sharedModules ++ [ ./hosts/${hostName} ];
      };
    in
    {
      nixosConfigurations = {
        kirby = mkHost "kirby";
        woo = mkHost "woo";
      };
    };
}
