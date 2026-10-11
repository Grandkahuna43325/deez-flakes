{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    nixpkgs-fmt
    nil
    nodejs
    go
    fd
    jq
    libxml2
    dockerfile-language-server
    docker-compose-language-service
    lua
    luajitPackages.luarocks
    luajitPackages.jsregexp
    tree-sitter
    sqlite
    gdb
    #lldb_17
    jdt-language-server
    typescript
    gradle_8
    # openjdk17
    openjdk21
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    JAVA_HOME = "${pkgs.openjdk21}/lib/openjdk";
  };
}
