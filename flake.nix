{
  description = "Grandkahuna's config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # nix-ld.url = "github:Mic92/nix-ld";
    # nix-ld.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, ... }:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations = {
        nixos = lib.nixosSystem {
          inherit system;
          modules = [ 
            ./configuration.nix
<<<<<<< HEAD
            nixos-hardware.nixosModules.microsoft-surface-pro-intel
=======
            nixos-hardware.nixosModules.microsoft-surface-surface-pro-intel
>>>>>>> a664f90 (first laptop commit)
          ];
        };
      };
      homeConfigurations = {
        grandkahuna43325 = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home.nix ];
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
