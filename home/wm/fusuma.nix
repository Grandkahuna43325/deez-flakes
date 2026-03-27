{ pkgs-unstable, ... }:
{
  option.services.fusuma = {
    enable = true;
    package = pkgs-unstable.fusuma;
    settings = {
      swipe = {
        "3" = {
          up.command = "wvkbd-mobintl";

          # down.command = "pkill wvkbd-mobintl";
          down.command = "notify-send 'nudes'";

          left.command = "hyprctl dispatch workspace prev";
          right.command = "hyprctl dispatch workspace next";
        };
      };
      # pinch = {
      #   "2" = {
      #     "in".command = "xdotool keydown ctrl click 4 keyup ctrl"; # zoom in
      #     "out".command = "xdotool keydown ctrl click 5 keyup ctrl"; # zoom out
      #   };
      # };
      hold = {
        "2".command = "notify-send 'nudes'";
      };
    };
  };
}
