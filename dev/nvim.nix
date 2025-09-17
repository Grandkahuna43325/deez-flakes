{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    nixpkgs-fmt
    nil
    nodejs
    go
    fd
    dockerfile-language-server-nodejs
    docker-compose-language-service
    lua
    luajitPackages.luarocks
    luajitPackages.jsregexp
    gdb
  ];

  home.sessionVariables = {
     EDITOR = "nvim";
  };
}
