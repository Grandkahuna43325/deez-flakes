{ pkgs, ... }:
{
  home.packages = with pkgs; [
    fastfetch
    ripgrep
    bat
    eza
    tldr
    feh
    devenv
    fzf
    ranger
    bottom
    httpie
  ];
}
