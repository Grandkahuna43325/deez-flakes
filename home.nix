{ config, pkgs, pkgs-unstable, catppuccin, ... }:

{

  imports = [
    ./dev/bundle.nix
    ./pkgs/bundle.nix
  ];

  fonts.fontconfig.enable = true;
  home.packages = [
    pkgs.nerd-fonts.fira-code
    pkgs.nerd-fonts.hack
  ];

  home.username = "grandkahuna43325";
  home.homeDirectory = "/home/grandkahuna43325";
  nixpkgs.config.allowUnfree = true;


  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/grandkahuna43325/etc/profile.d/hm-session-vars.sh
  #
  catppuccin = {
    flavor = "mocha";
    enable = true;
  };
  programs.element-desktop.enable = true;

  programs.home-manager.enable = true;
  home.stateVersion = "25.05";
}
