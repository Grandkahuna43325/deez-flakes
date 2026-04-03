{ pkgs, ... }:
{
  home.packages = [
    pkgs.dunst
  ];

  services.dunst = {
    enable = true;
    settings = {
      global = {
        monitor = 1;
        indicate_hidden = "yes";
        shrink = "no";
        transparency = 80;
        separator_height = 0;
        padding = 8;
        horizontal_padding = 8;
        frame_width = 2;
        separator_color = "#b0bec5";
        sort = "yes";
        font = "FiraCode Nerd Font 14";
        vertical_alignment = "top";
        stack_duplicates = true;
        hide_duplicate_count = true;
        icon_position = "off";
        min_icon_size = 32;
        max_icon_size = 32;
        browser = "firefox";
      };

      urgency_low = {
        background = "#253238";
        foreground = "#b0bec5";
        frame_color = "#80f980";
        timeout = 5;
      };

      urgency_normal = {
        background = "#253238";
        foreground = "#b0bec5";
        frame_color = "#ebdbb2";
        timeout = 5;
      };

      urgency_critical = {
        background = "#253238";
        foreground = "#FFCC00";
        frame_color = "#eb334d";
        timeout = 5;
      };
    };
  };
}
