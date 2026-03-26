{ pkgs, inputs, ... }:

{
  home.packages = [
    inputs.hyprgrass.packages.${pkgs.system}.default
  ];

}
