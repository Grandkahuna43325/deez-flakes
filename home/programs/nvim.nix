{ pkgs, pkgs-unstable, ... }:

{
  home.packages = with pkgs; [
    pkgs-unstable.neovim
    nixpkgs-fmt
    nil
    nodejs
    go
    fd
    dockerfile-language-server
    docker-compose-language-service
    lua
    luajitPackages.luarocks
    luajitPackages.jsregexp
    # gdb
    sqlite
  ];

  home.sessionVariables = {
     EDITOR = "nvim";
  };
}

