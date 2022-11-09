{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.starship;
  initZshPath = "${config.xdg.configHome}/starship/starship.zsh";
in {
  config = mkIf cfg.enable {
    programs = {
      zsh.initExtra = ''
         if [[ $TERM != "dumb" && (-z $INSIDE_EMACS || $INSIDE_EMACS == "vterm") ]]; then
          source ${initZshPath}
          enable_transience
        fi
      '';
    };

    home.file = {
      "starship.zsh" = {
        source = ./starship.zsh;
        target = "${initZshPath}";
      };
    };
  };
}
