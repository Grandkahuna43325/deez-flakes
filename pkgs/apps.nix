{configs, pkgs, pkgs-unstable, ...}:

{
  home.packages = with pkgs; [
    gh
    git
    pavucontrol
    mpv
    yt-dlp
    qbittorrent
    libreoffice
    # gimp
    inkscape
    vlc
    chromium
    xournalpp
    drawio
    pkgs-unstable.vesktop
    pkgs-unstable.figma-linux
    pkgs-unstable.gimp3
  ];

  programs.gh.enable = true;
  programs.git = {
    enable = true;
    userName = "Grandkahuna43325";
    userEmail = "kf.korulczyk@gmail.com";
    extraConfig.init.defaultBranch = "main";
  };
}

