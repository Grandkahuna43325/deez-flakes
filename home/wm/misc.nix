{ pkgs, ... }:
{
  home.packages = [
    pkgs.xclip
    pkgs.wl-clipboard
    pkgs.wvkbd
    pkgs.libnotify
    pkgs.waybar
  ];
}
