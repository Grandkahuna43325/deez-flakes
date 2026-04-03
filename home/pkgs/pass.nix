{configs, pkgs, ...}:

{
  home.packages = with pkgs; [
    pinentry-curses
    gnupg
    pass
    wofi-pass
  ];

}

