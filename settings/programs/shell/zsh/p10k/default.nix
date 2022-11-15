{ config, pkgs, ... }:

let dotDir = "${config.xdg.configHome}/zsh";
in {
  home.file = {
    "p10k.zsh" = {
      source = ./p10k.zsh;
      target = "${dotDir}/p10k.zsh";
    };
  };
}
