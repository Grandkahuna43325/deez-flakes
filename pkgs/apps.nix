{configs, pkgs, ...}:

{
  home.packages = with pkgs; [
    gh
    git
    vesktop
    pavucontrol
    mpv
    yt-dlp
  ];

  programs.git = {
    enable = true;
    userName = "Grandkahuna43325";
    userEmail = "kf.korulczyk@gmail.com";
    extraConfig.init.defaultBranch = "main";
  };
}

