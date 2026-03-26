{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    gnumake
    rustup
    gcc
  ];

}
