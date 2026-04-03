{pkgs, pkgs-unstable, ...}:

{
  home.packages = with pkgs; [
    pkgs-unstable.scrcpy
    android-tools
    gnirehtet
  ];
}

