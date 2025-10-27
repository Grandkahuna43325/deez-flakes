{ configs, pkgs, ... }:

{
  home.packages = with pkgs; [
    xclip
    wl-clipboard
    grim
    slurp
    wofi
    picom
    dunst
    libnotify
    hyprpaper
    hyprshot
    #separate config
    waybar
    hyprland

    #welp I use hyprpaper so gb nitrogen
    # nitrogen
  ];


  services.picom = {
    enable = true;
    backend = "xrender";
    vSync = true;
    menuOpacity = 0.8;
    activeOpacity = 1;
    inactiveOpacity = 0.8;
    wintypes = {
      tooltip = { fade = true; shadow = true; full-shadow = true; };
      dock = { fade = true; shadow = true; full-shadow = true; };
      dnd = { fade = true; shadow = true; full-shadow = true; };
      popup_menu = { fade = true; shadow = true; full-shadow = true; };
      dropdown_menu = { fade = true; shadow = true; full-shadow = true; };
    };
    opacityRules = [
      "10:class_g = 'URxvt' && !focused"
      "10:class_g = 'dunst'"
    ];

  };

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

  services.hyprpaper = {
    enable = true;
    settings = {
      preload =
        [ "/home/grandkahuna43325/.dotfiles/pkgs/wallpapa/2111.jpg" "/home/grandkahuna43325/.dotfiles/pkgs/wallpapa/2113.jpg" ];
      wallpaper = [
        "DP-1,/home/grandkahuna43325/.dotfiles/pkgs/wallpapa/2111.jpg"
        "DP-3,/home/grandkahuna43325/.dotfiles/pkgs/wallpapa/2111.jpg"
        "eDP-1,/home/grandkahuna43325/.dotfiles/pkgs/wallpapa/2111.jpg"
        "HDMI-A-1,/home/grandkahuna43325/.dotfiles/pkgs/wallpapa/2113.jpg"
      ];
    };
  };

  programs.wofi = {
    enable = true;
    settings = {
      allow_images = true;
    };
    style = ''
      /* The name of the window itself */
      #window {
        background-color: rgba(24, 24, 24, 0.6);
        box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -4px rgba(0, 0, 0, 0.1);
        border-radius: 1rem;
        font-size: 1.2rem;
        /* The name of the box that contains everything */
      }
      #window #outer-box {
        /* The name of the search bar */
        /* The name of the scrolled window containing all of the entries */
      }
      #window #outer-box #input {
        background-color: rgba(24, 24, 24, 0.6);
      color: #f2f2f2;
      border: none;
              border-bottom: 1px solid rgba(24, 24, 24, 0.2);
      padding: 0.8rem 1rem;
               font-size: 1.5rem;
               border-radius: 1rem 1rem 0 0;
      }
      #window #outer-box #input:focus, #window #outer-box #input:focus-visible, #window #outer-box #input:active {
      border: none;
      outline: 2px solid transparent;
               outline-offset: 2px;
      }
      #window #outer-box #scroll {
        /* The name of the box containing all of the entries */
      }
      #window #outer-box #scroll #inner-box {
        /* The name of all entries */
        /* The name of all boxes shown when expanding  */
        /* entries with multiple actions */
      }
      #window #outer-box #scroll #inner-box #entry {
      color: #fff;
             background-color: rgba(24, 24, 24, 0.5);
      padding: 0.6rem 1rem;
               /* The name of all images in entries displayed in image mode */
               /* The name of all the text in entries */
      }
      #window #outer-box #scroll #inner-box #entry #img {
      width: 1rem;
             margin-right: 0.5rem;
      }
      #window #outer-box #scroll #inner-box #entry:selected {
      color: #fff;
             background-color: rgba(255, 255, 255, 0.1);
      outline: none;
      }
    '';

  };
}
