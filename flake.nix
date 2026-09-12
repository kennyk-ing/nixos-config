{
  description = "Kenny's NixOS Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixvim.url = "github:nix-community/nixvim/nixos-26.05";

    privateData = {
      url = "git+ssh://git@github.com/kennyk-ing/nixos-private.git";
      flake = false;
    };

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    carl-theme = {
      url = "git+https://gitlab.com/jomada/carl.git";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      agenix,
      disko,
      ...
    }@inputs:
    let
      system = "x86_64-linux";

      pkgs = nixpkgs.legacyPackages.${system};

      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };

      gitHooks = inputs.git-hooks.lib.${system}.run {
        src = ./.;
        hooks = import ./git-hooks.nix;
      };

      sharedModules = [
        { nixpkgs.hostPlatform = system; }

        agenix.nixosModules.default
        disko.nixosModules.default
        inputs.nixvim.nixosModules.nixvim

        ./modules
        ./users

        home-manager.nixosModules.home-manager
        {
          home-manager = {
            extraSpecialArgs = { inherit inputs pkgs-unstable; };
            useGlobalPkgs = true;
            useUserPackages = true;

            sharedModules = [
              inputs.plasma-manager.homeModules.plasma-manager
              ./users/common/onlyoffice.nix
              ./users/common/plasma-power.nix
            ];
          };
        }
      ];

      mkHost =
        hostName:
        nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs pkgs-unstable; };
          modules = sharedModules ++ [ ./hosts/${hostName} ];
        };
    in
    {
      nixosConfigurations = {
        kingdome = mkHost "kingdome";
        kingdome-installer = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs self;
          };

          modules = [
            { nixpkgs.hostPlatform = system; }
            ./installer/kingdome
          ];
        };

        kirby = mkHost "kirby";
        tez = mkHost "tez";
        woo = mkHost "woo";
      };

      formatter.${system} = pkgs.nixfmt-tree;
      checks.${system}.pre-commit = gitHooks;

      devShells.${system}.default = pkgs.mkShellNoCC {
        packages = [
          pkgs.nixd
          pkgs.nixfmt
          pkgs.nixfmt-tree
          pkgs.age
          agenix.packages.${system}.default
        ]
        ++ gitHooks.enabledPackages;

        inherit (gitHooks) shellHook;
      };
    };
}
