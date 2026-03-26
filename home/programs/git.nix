{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gh
    git
  ];

  programs = {
    gh = {
      enable = true;
      settings.editor = "nvim";
    };
    git.settings = {
      enable = true;
      userName = "Grandkahuna43325";
      userEmail = "kf.korulczyk@gmail.com";
      extraConfig.init.defaultBranch = "main";
    };
  };
}
