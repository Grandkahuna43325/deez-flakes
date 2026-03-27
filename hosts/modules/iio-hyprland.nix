{ pkgs, inputs, ... }:
{
  environment.systemPackages = [
    inputs.iio-hyprland.packages.${pkgs.system}.default
  ];

  programs.iio-hyprland = {
    enable = true;
  };

  hardware.sensor.iio.enable = true;
}
