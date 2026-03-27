{ inputs, pkgs, ... }:
{
  # imports = [ inputs.hyprland.nixosModules.default ];
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;

    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;

    plugins = [
      # inputs.hyprgrass.packages.${pkgs.system}.default
      # inputs.hyprgrass.packages.${pkgs.system}.hyprgrass-pulse
    ];

    settings = {
      plugin.touch_gestures = {
        hyprgrass-bind = [
          ", edge:d:u, exec, wvkbd-toggle"
          ", edge:u:d, killactive"
        ];

        sensitivity = 2.0;
        workspace_swipe_fingers = 3;
        workspace_swipe_edge = "d";
        long_press_delay = 400;
        resize_on_border_long_press = true;
        edge_margin = 10;
        emulate_touchpad_swipe = false;
      };

      exec-once = [
        "wl-clipboard-history -t"
        "~/.config/hypr/xdg-portal-hyprland"
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "/usr/lib/polkit-kde-authentication-agent-1"
        "hyprpaper"
        "waybar"
        "dunst"
        "alacritty"
        "iio-hyprland"
        # "~/.config/hypr/background.sh";
      ];

      monitor = [
        "HDMI-A-1,1920x1080@60,0x0,1"
        "DP-2,1920x1080@144,1920x0,1"
      ];


      input = {
        kb_layout = "pl";
        follow_mouse = "1";
        sensitivity = "0"; # -1.0 - 1.0, 0 means no modification.
        touchpad = {
          disable_while_typing = "true";
          natural_scroll = "true";
        };
      };

      general = {
        gaps_in = 10;
        gaps_out = 15;
        border_size = 1;
        "col.inactive_border" = "rgba(f7768eff) rgba(73dacaff) 45deg";
        "col.active_border" = "rgba(73daca00) rgba(f7768e00) 45deg";
        layout = "dwindle";
      };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        mouse_move_enables_dpms = true;
        enable_swallow = true;
        swallow_regex = "^(alacritty)$";
      };

      decoration = {
        rounding = "16";

        active_opacity = 1.0;
        inactive_opacity = 0.8;

        "blur:enabled" = false;
        "blur:size" = 2;
        "blur:passes" = 2;
      };


      animations = {
        enabled = true;
        bezier = [
          "overshot, 0.05, 0.5, 0.1, 1.05"
          "smoothOut, 0.36, 0, 0.66, -0.56"
          "smoothIn, 0.25, 0.8, 0.5, 1"
        ];


        animation = [
          "windows, 1, 5, overshot, slide"
          "windowsOut, 1, 4, smoothOut, slide"
          "windowsMove, 1, 4, default"
          "border, 1, 10, default"
          "fade, 1, 10, smoothIn"
          "fadeDim, 1, 10, smoothIn"
          "workspaces, 1, 6, default"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      windowrule = [
        "match:class file_progress, float on"
        "match:class confirm, float on"
        "match:class dialog, float on"
        "match:class download, float on"
        "match:class notification, float on"
        "match:class error, float on"
        "match:class splash, float on"
        "match:class confirmreset, float on"
        "match:title .*Open File.*, float on"
        "match:title branchdialog, float on"
        "match:class Lxappearance, float on"
        "match:class wofi, float on"
        "match:class viewnior, float on"
        "match:class feh, float on"
        "match:class pavucontrol-qt, float on"
        "match:class pavucontrol, float on"
        "match:class file-roller, float on"
        "match:class wlogout, fullscreen on"
        "match:title wlogout, float on"
        "match:title wlogout, fullscreen on"
        "match:title ^(Media viewer)$, float on"
        "match:title ^(Volume Control)$, float on"
        "match:title ^(Picture-in-Picture)$, float on"
        "match:title ^(Volume Control)$, size 800 600"
        "match:title ^(Volume Control)$, move 39% 420"

        # Always open some programs on specified workspace
        # NOTE: Adjust the workspace names/numbers as per your setup.
        "workspace 2, match:class alacritty"
        "workspace 5, match:title ^(.*Firefox.*)$"
      ];

      # Keybindings
      bind = [
        "SUPER, X, exec, alacritty"
        "SUPER, Q, killactive"
        "SUPER, r, exec, wofi --show drun"
        "SUPER, p, exec, wofi-pass"

        # Move between workspaces
        "SUPER, H, movefocus, left"
        "SUPER, L, movefocus, right"

        # Move focused window
        "SUPER, O, movetoworkspace, next"

        # Fullscreen mode
        "SUPER, F, fullscreen"

        # Switch to workspace
        "SUPER, 1, workspace, 1"
        "SUPER, 2, workspace, 2"
        "SUPER, 3, workspace, 3"
        "SUPER, 4, workspace, 4"
        "SUPER, 5, workspace, 5"
        "SUPER, 6, workspace, 6"
        "SUPER, 7, workspace, 7"
        "SUPER, 8, workspace, 8"
        "SUPER, 9, workspace, 9"
        "SUPER, 0, workspace, 10"

        # Move container to workspace
        "SUPER+SHIFT, 1, movetoworkspace, 1"
        "SUPER+SHIFT, 2, movetoworkspace, 2"
        "SUPER+SHIFT, 3, movetoworkspace, 3"
        "SUPER+SHIFT, 4, movetoworkspace, 4"
        "SUPER+SHIFT, 5, movetoworkspace, 5"
        "SUPER+SHIFT, 6, movetoworkspace, 6"
        "SUPER+SHIFT, 7, movetoworkspace, 7"
        "SUPER+SHIFT, 8, movetoworkspace, 8"
        "SUPER+SHIFT, 9, movetoworkspace, 9"
        "SUPER+SHIFT, 0, movetoworkspace, 10"


        # Lock screen
        "SUPER+SHIFT, R, exec, shutdown now"

        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"

        "SUPER, h, movefocus, l"
        "SUPER, l, movefocus, r"
        "SUPER, k, movefocus, u"
        "SUPER, j, movefocus, d"

        "SUPER SHIFT, h, movewindow, l"
        "SUPER SHIFT, l, movewindow, r"
        "SUPER SHIFT, k, movewindow, u"
        "SUPER SHIFT, j, movewindow, d"

        "SUPER CTRL, h, resizeactive, -20 0"
        "SUPER CTRL, l, resizeactive, 20 0"
        "SUPER CTRL, k, resizeactive, 0 -20"
        "SUPER CTRL, j, resizeactive, 0 20"
      ];


      binde = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ];


      workspace = [
        # Workspaces
        "1, '1:  '"
        "2, '2:  '"
        "3, '3:  '"
        "4, '4:  '"
        "5, '5:  '"
        "6, '6:  '"
        "7, '7:  '"
        "8, '8: ♫ '"
        "9, '9:  '"
        "10, '10:  '"
      ];
    };
  };
}
