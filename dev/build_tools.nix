{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    gnumake
    rustup
    maven
    # cargo-tauri
    gcc
  ];

}
