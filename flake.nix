{
  description = "Grandkahuna's config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    catppuccin.url = "github:catppuccin/nix/6247b46";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    # nix-ld.url = "github:Mic92/nix-ld";
    # nix-ld.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, catppuccin, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      pkgsUnstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations = {
        nixos = lib.nixosSystem {
          inherit system;
          modules = [
            ./configuration.nix
            # { nixpkgs.config.allowUnfree = true; }
          ];
          specialArgs = { inherit inputs pkgsUnstable; };
        };
        grandkahuna43325 = lib.nixosSystem {
          inherit system;
          modules = [
            ./configuration.nix
            catppuccin.nixosModules.catppuccin
            home-manager.nixosModules.home-manager
          ];
          specialArgs = { inherit inputs pkgsUnstable; };
        };
      };
      homeConfigurations = {
        grandkahuna43325 = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system}; # Ensure `pkgs` is properly set
          modules = [
            ./home.nix
            catppuccin.homeModules.catppuccin
          ];
          extraSpecialArgs = {
            pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
          };
        };
      };

      #nix-ld
      # nixosConfigurations.grandkahuna43325 = nixpkgs.lib.nixosSystem {
      #   inherit system;
      #   modules = [
      #     # ... add this line to the rest of your configuration modules
      #     nix-ld.nixosModules.nix-ld
      #
      #     # The module in this repository defines a new module under (programs.nix-ld.dev) instead of (programs.nix-ld)
      #     # to not collide with the nixpkgs version.
      #     { programs.nix-ld.dev.enable = true; }
      #   ];
      # };
    };
}
