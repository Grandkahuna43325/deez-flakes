{configs, pkgs, ...}:

{
  home.packages = with pkgs; [
    gh
    git
    pavucontrol
    mpv
    yt-dlp
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
    telegram-desktop
    vesktop
    figma-linux
    gimp3
    caprine
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
    settings = {
      user.name = "Grandkahuna43325";
      user.email = "kf.korulczyk@gmail.com";
      init.defaultBranch = "main";
    };
  };
}

