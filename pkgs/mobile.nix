{pkgs, pkgs-unstable, ...}:

{
  home.packages = with pkgs; [
    scrcpy
    android-tools
    gnirehtet
  ];
}

