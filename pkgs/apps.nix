{configs, pkgs, pkgs-unstable, ...}:

{
  home.packages = with pkgs; [
    gh
    git
    webcord-vencord
    pavucontrol
    mpv
    yt-dlp
    libreoffice-qt
    gimp
    inkscape
    ddccontrol
    pkgs-unstable.xournalpp
    pkgs-unstable.figma-linux
    # required by xournalpp 
    gnome.adwaita-icon-theme
  ];

  programs.gh.enable = true;
  programs.git = {
    enable = true;
    userName = "Grandkahuna43325";
    userEmail = "kf.korulczyk@gmail.com";
    extraConfig.init.defaultBranch = "main";
  };
}

