{ pkgs, ... }:

{
  home.packages = with pkgs; [
    zellij
  ];

  programs.zellij = {
    enable = true;
  }; 
}
