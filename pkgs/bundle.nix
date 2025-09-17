{ config, pkgs, ... }:

{

  imports = [
    ./apps.nix
    ./wm.nix
    ./games.nix
    ./qt-browser.nix
    ./pass.nix
    ./obs.nix
  ];
}
