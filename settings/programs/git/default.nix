{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    git
    gitAndTools.delta
  ];

  programs.git = {
    enable = true;
    userName = "Daehyeok Mun";
    includes = [ { path = ./gitconfig_delta; } ];
  };
}
