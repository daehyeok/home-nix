{ config, pkgs, lib, ... }:
with lib; {
  home.packages = with pkgs; [ ];

  home.file = {
    "kitty.conf" = {
      source = pkgs.substituteAll {
        src = ./kitty.conf;
        fontSize = if pkgs.stdenv.isDarwin then 13 else 20;
      };
      target = ".config/kitty/kitty.conf";
    };
  };
}