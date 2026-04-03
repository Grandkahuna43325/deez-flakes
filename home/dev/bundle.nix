{ config, pkgs, ... }:

{

  imports = [
    ./nvim.nix
    ./sh.nix
    ./build_tools.nix
  ];

}
