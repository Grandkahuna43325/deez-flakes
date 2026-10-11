{ pkgs, ... }:

{
  home.packages = [
    pkgs.hyprsunset
    # inputs.hyprpaper.packages.${pkgs.stdenv.hostPlatform.system}.hyprpaper
  ];

  services.hyprsunset = {
    enable = true;
    settings = {
      max-gamma = 150;
      profile = [
        {
          time = "7:30";
          identity = true;
        }
        {
          time = "20:00";
          gamma = 0.7;
        }
      ];
    };
  };

}

