{ pkgs, ... }:

{
  home.packages = [
    pkgs.hyprpaper
    # inputs.hyprpaper.packages.${pkgs.stdenv.hostPlatform.system}.hyprpaper
  ];

  services.hyprpaper = {
    enable = true;
    settings = {
      preload =
        [
          "/home/grandkahuna43325/.dotfiles/home/wm/hyprpaper/wallpapa/2111.jpg"
          "/home/grandkahuna43325/.dotfiles/home/wm/hyprpaper/wallpapa/2113.jpg"
        ];
      wallpaper = [
        "eDP-1,/home/grandkahuna43325/.dotfiles/pkgs/wallpapa/2111.jpg"
        "HDMI-A-1,/home/grandkahuna43325/.dotfiles/pkgs/wallpapa/2113.jpg"
      ];
    };
  };

}
