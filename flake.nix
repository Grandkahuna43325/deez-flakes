{
  description = "Grandkahuna's config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # change this when updating kernel
    # nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixos-hardware.url = "github:8bitbuddhist/nixos-hardware?ref=surface-kernel-6.18";

    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
      inputs.hyprland.follows = "hyprland";
    };

    # hyprgrass = {
    #   url = "github:horriblename/hyprgrass";
    #   inputs.hyprland.follows = "hyprland";
    # };

    # nix-ld.url = "github:Mic92/nix-ld";
    # nix-ld.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, nixos-hardware, hyprland, ... }@inputs:
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
            nixos-hardware.nixosModules.microsoft-surface-pro-intel
          ];
          specialArgs = { inherit inputs; };
        };
      };
      homeConfigurations = {
        grandkahuna43325 = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            # {
            #   wayland.windowManager.hyprland = {
            #     enable = true;
            #     xwayland.enable = true;
            #     # set the flake package
            #     package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
            #     portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
            #     plugins = [
            #       inputs.hyprgrass.packages.${pkgs.system}.default
            #
            #       # optional integration with pulse-audio, see examples/hyprgrass-pulse/README.md
            #       inputs.hyprgrass.packages.${pkgs.system}.hyprgrass-pulse
            #     ];
            #     settings = {
            #       gestures = {
            #         # built-in gesture to switch workspaces
            #         workspace_swipe = true;
            #         workspace_swipe_touch = true;
            #         workspace_swipe_cancel_ratio = 0.15;
            #       };
            #
            #       plugin = {
            #         touch_gestures = {
            #           hyprgrass-bind = [
            #             #from bottom edge up: toggle wvkbd
            #             ", edge:d:u, exec, wvkbd-toggle"
            #             #from upper edge down: kill the active window
            #             ", edge:u:d, killactive"
            #           ];
            #
            #
            #           # The default sensitivity is probably too low on tablet screens,
            #           # I recommend turning it up to 4.0
            #           sensitivity = 2.0;
            #
            #           # must be >= 3
            #           workspace_swipe_fingers = 3;
            #
            #           # switching workspaces by swiping from an edge, this is separate from workspace_swipe_fingers
            #           # and can be used at the same time
            #           # possible values: l, r, u, or d
            #           # to disable it set it to anything else
            #           workspace_swipe_edge = "d";
            #
            #           long_press_delay = 400; # in milliseconds
            #
            #           resize_on_border_long_press = true;
            #
            #           edge_margin = 10;
            #           emulate_touchpad_swipe = false;
            #         };
            #       };
            #     };
            #   };
            # }
            ./home.nix
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
