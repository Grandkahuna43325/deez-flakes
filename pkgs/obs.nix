{ configs, pkgs, ... }:

{
  home.packages = with pkgs; [
    # obs-studio
  ];

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-backgroundremoval
      obs-pipewire-audio-capture
      # obs-ndi
      obs-teleport
      wlrobs
    ];
  };
}
