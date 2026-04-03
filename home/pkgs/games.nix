{ configs, pkgs, pkgs-unstable, ... }:

{
  home.packages = with pkgs; [
    prismlauncher
    # lutris
    dwarfs
    fuse-overlayfs
    bubblewrap
    winePackages.staging
    gamemode
    sc-controller
    # alsaPlugins
    # lib32.alsaPlugins
    # libpulse
    # lib32.libpulse
    # pipewire
    # lib32.pipewire
  ];
}
