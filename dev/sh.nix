{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    fastfetch
    ripgrep
    bat
    eza
    zoxide
    zsh-powerlevel10k
    zsh-syntax-highlighting
    zsh-history-substring-search
    thefuck
    tldr
    feh
    devenv
    fzf
    ranger
    nix-prefetch

    #separate config
    zellij
    zsh
    oh-my-zsh
    alacritty
  ];

  programs.zoxide.options = [
    "--cmd cd"
  ];

  programs.zoxide.enable = true;
  programs.zoxide.enableZshIntegration = true;


  # Disabling zhs to manage it from ~/.zshrc and not home-manager
  programs.zsh.enable = false;
}
