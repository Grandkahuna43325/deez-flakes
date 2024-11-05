{configs, pkgs, ...}:

{
  home.packages = with pkgs; [
    gh
    git
    webcord-vencord
    pavucontrol
    mpv
    yt-dlp
    xournalpp
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

