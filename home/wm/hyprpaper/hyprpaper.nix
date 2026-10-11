{ pkgs, ... }:

{
  home.packages = [
    pkgs.hyprpaper
    # inputs.hyprpaper.packages.${pkgs.stdenv.hostPlatform.system}.hyprpaper
  ];

  services.hyprpaper = {
    enable = true;
    settings = {
      wallpaper = [
        {
          monitor = "DP-1";
          path = "/home/grandkahuna43325/.dotfiles/home/wm/hyprpaper/wallpapa/2111.jpg";
          fit_mode = "cover";
        }
        {
          monitor = "DP-3";
          path = "/home/grandkahuna43325/.dotfiles/home/wm/hyprpaper/wallpapa/2113.jpg";
          fit_mode = "cover";
        }
        {
          monitor = "HDMI-A-1";
          path = "/home/grandkahuna43325/.dotfiles/home/wm/hyprpaper/wallpapa/2111.jpg";
          fit_mode = "cover";
        }
      ];
      # preload =
      #   [
      #     "/home/grandkahuna43325/.dotfiles/home/wm/hyprpaper/wallpapa/2111.jpg"
      #     "/home/grandkahuna43325/.dotfiles/home/wm/hyprpaper/wallpapa/2113.jpg"
      #   ];
      # wallpaper = [
      #   "DP-1,/home/grandkahuna43325/.dotfiles/home/wm/hyprpaper/wallpapa/2111.jpg"
      #   "DP-3,/home/grandkahuna43325/.dotfiles/home/wm/hyprpaper/wallpapa/2113.jpg"
      #   "HDMI-A-1,/home/grandkahuna43325/.dotfiles/home/wm/hyprpaper/wallpapa/2113.jpg"
      # ];
    };
  };

}
