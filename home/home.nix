{ config, pkgs, pkgs-unstable, ... }:

{

  imports = [
    ./sh/bundle.nix
    ./wm/bundle.nix
    ./programs/bundle.nix
  ];


  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.hack
  ];

  home.username = "grandkahuna43325";
  home.homeDirectory = "/home/grandkahuna43325";
  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;
  home.stateVersion = "25.11";
}
