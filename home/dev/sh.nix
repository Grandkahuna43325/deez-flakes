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
    tldr
    feh
    devenv
    fzf
    ranger
    nix-prefetch
    carapace
    bottom
    httpie
    trash-cli
    posting
    busybox
    sshfs
    postgresql

    ueberzugpp

    #separate config
    zellij
    zsh
    oh-my-zsh
    alacritty
  ];

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    sshKeys = [
      "6BA1914EFE25B292ABD7DEC9D4B6C226EE2E1374"
    ];
  };

  programs.ssh.matchBlocks = {
    "*.kfkorulczyk.pl" = {
      proxyCommand = "ProxyCommand /run/current-system/sw/bin/cloudflared access ssh --hostname %h";
    };
  };

  programs.zoxide.options = [
    "--cmd cd"
  ];

  programs.zoxide.enable = true;
  programs.zoxide.enableZshIntegration = true;


  programs.carapace.enable = true;
  programs.zsh = {
    enable = true;
    initContent = ''
      export MANPAGER="nvim +Man!"
      export MANWIDTH=999
      unset SSH_AGENT_PID
      if [ "''${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
        export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
      fi
      gpgconf --launch gpg-agent
      precmd() { print -Pn "\e]0;%1~\a" }
    '';
    envExtra = ''
      source ~/.env
      source ~/.p10k.zsh
    '';

    shellAliases = {
      q = "exit";
      e = "cd";
      gp = "git pull";
      cat = "bat";
      ff = "fastfetch";
      cf = "cc";
      ll = "exa --all --long -I '.*'";
      man = "colored man";
      ld = "exa --all --tree --level=2 --long --inode";
      ls = "exa --all --long --inode  --ignore-glob='.git*'";
      z = "cd";
      rm = "trash-put";
      mountssh = "
      sshfs Grandkahuna43325@192.168.88.51:/mnt/pool/Personal ~/Personal && 
      sshfs -o uid=$(id -u) -o gid=$(id -g) root@alpine-private:/root ~/remotes/alpine-private/
      ";
    };
    plugins = [
      {
        name = "zsh-autosuggestions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-autosuggestions";
          rev = "v0.7.0";
          sha256 = "1g3pij5qn2j7v7jjac2a63lxd97mcsgw6xq6k5p7835q9fjiid98";
        };
      }
      {
        name = "zsh-completions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-completions";
          rev = "0.35.0";
          sha256 = "164jw74qlrpl6lawa4wjyhn2d04zw36ac0jsg4r6ql8769kfal8q";
        };
      }
      {
        name = "zsh-powerlevel10k";
        src = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/";
        file = "powerlevel10k.zsh-theme";
      }
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "0.8.0";
          sha256 = "1yl8zdip1z9inp280sfa5byjbf2vqh2iazsycar987khjsi5d5w8";
        };
      }
    ];

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "history-substring-search"
        "vi-mode"
        "bgnotify"
        "colorize"
        "colored-man-pages"
        "command-not-found"
        "docker"
        "gitfast"
      ];
      extraConfig = ''
        DISABLE_AUTO_TITLE="true"
      '';
    };
  };
}
