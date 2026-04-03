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

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };


    # nix-ld.url = "github:Mic92/nix-ld";
    # nix-ld.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, catppuccin, home-manager, hyprland, ... }@inputs:
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
            # home-manager.nixosModules.home-manager
          ];
          specialArgs = { inherit inputs pkgsUnstable; };
        };
      };
      homeConfigurations = {
        grandkahuna43325 = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit inputs;
            pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
          };
          modules = [
            ./home/home.nix
            catppuccin.homeModules.catppuccin
          ];
        };
      };
    };
}
