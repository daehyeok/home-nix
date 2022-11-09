{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.p10k;
  dotDir = "${config.xdg.configHome}/zsh";
in {
  options = { programs.p10k = { enable = mkOption { default = false; }; }; };

  config.programs = mkIf cfg.enable {
    zinit = {
      plugins = [{
        repo = "romkatv/powerlevel10k";
        initExtra = ''
          [[ ! -f "${dotDir}/p10k_work.zsh" ]] || zinit snippet ${dotDir}/p10k_work.zsh
          [[ ! -f "${dotDir}/p10k.zsh" ]] || zinit snippet  ${dotDir}/p10k.zsh
        '';
      }];
    };
    zsh = {
      initExtraFirst = ''
        P10K_INSTANT_PROMPT="${config.xdg.cacheHome}/p10k-instant-prompt-''${(%):-%n}.zsh"
                     [[ ! -r "$P10K_INSTANT_PROMPT" ]] || source "$P10K_INSTANT_PROMPT"
      '';
    };
  };
}
