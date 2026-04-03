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
        "DP-1,/home/grandkahuna43325/.dotfiles/home/wm/hyprpaper/wallpapa/2111.jpg"
        "DP-3,/home/grandkahuna43325/.dotfiles/home/wm/hyprpaper/wallpapa/2113.jpg"
        "HDMI-A-1,/home/grandkahuna43325/.dotfiles/home/wm/hyprpaper/wallpapa/2113.jpg"
      ];
    };
  };

}
