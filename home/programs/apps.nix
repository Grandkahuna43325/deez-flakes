{pkgs, pkgs-unstable, ...}:

{
  home.packages = with pkgs; [
    pkgs-unstable.xournalpp
    # !!! move
    adwaita-icon-theme

    webcord-vencord
    libreoffice-qt
    gimp
    moonlight-qt


    pavucontrol
  ];
}

