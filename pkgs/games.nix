{configs, pkgs, ...}:

{
  home.packages = with pkgs; [
    prismlauncher
    lutris
  ];
}

