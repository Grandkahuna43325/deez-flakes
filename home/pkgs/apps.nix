{configs, pkgs, pkgs-unstable, ...}:

{
  home.packages = with pkgs; [
    gh
    git
    pavucontrol
    mpv
    pkgs-unstable.yt-dlp
    (pkgs.python3.withPackages (ps: [ ps.mutagen ] ))
    qbittorrent
    libreoffice
    # gimp
    inkscape
    vlc
    chromium
    xournalpp
    drawio
    moonlight-qt
    pkgs-unstable.vesktop
    pkgs-unstable.figma-linux
    pkgs-unstable.gimp3
    pkgs-unstable.caprine
  ];

  services.mpd = {
    enable = true;
    musicDirectory = "/home/grandkahuna43325/Music";
    extraConfig = ''
      bind_to_address "/run/mpd/socket"
      audio_output {
        type "pipewire"
        name "PipeWire Sound Server"
      }
    '';
  };


  programs.gh.enable = true;
  programs.git = {
    enable = true;
    userName = "Grandkahuna43325";
    userEmail = "kf.korulczyk@gmail.com";
    extraConfig.init.defaultBranch = "main";
  };
}

