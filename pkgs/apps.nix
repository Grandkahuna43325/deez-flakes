{configs, pkgs, ...}:

{
  home.packages = with pkgs; [
    gh
    git
    webcord
    vesktop
    pavucontrol
    mpv
    yt-dlp
  ];

  programs.gh.enable = true;
  programs.git = {
    enable = true;
    userName = "Grandkahuna43325";
    userEmail = "kf.korulczyk@gmail.com";
    extraConfig.init.defaultBranch = "main";
  };
}

