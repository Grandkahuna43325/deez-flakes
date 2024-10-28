{ config, pkgs, ... }:

{

  imports = [
  #qute containers but first I have to understand them 
    ./apps.nix
    ./virtualization.nix
    ./wm.nix
    ./games.nix
    ./qt-browser.nix
    ./pass.nix
  ];
}
