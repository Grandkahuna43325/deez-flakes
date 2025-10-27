{ config, pkgs, pkgs-unstable, ... }:

{
  home.packages = with pkgs; [
    nixpkgs-fmt
    nil
    pkgs-unstable.nodejs
    go
    fd
    jq
    libxml2
    dockerfile-language-server-nodejs
    docker-compose-language-service
    lua
    luajitPackages.luarocks
    luajitPackages.jsregexp
    sqlite
    lldb_17
    jdk
    jdt-language-server
    typescript
    python314
    gradle
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
