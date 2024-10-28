{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    gnumake
    rustup
    cargo-tauri
    gcc
  ];

}
