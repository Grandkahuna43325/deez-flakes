{ pkgs, inputs, ... }:

{
  home.packages = [
    pkgs.picom
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
}
