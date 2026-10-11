{pkgs, ...}:
{
  home.packages = with pkgs; [
    scrcpy
    android-tools
    gnirehtet
  ];

}

