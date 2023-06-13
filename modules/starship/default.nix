{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.starship;
  initZshPath = "${config.xdg.configHome}/starship/starship.zsh";
  starshipCmd = "${config.home.profileDirectory}/bin/starship";
in {
  options = {
    programs.starship = { transientPrompt = mkOption { default = true; }; };
  };

  config = mkIf cfg.enable {
    programs = {
      starship = {
        enableZshIntegration = false;
        settings = {
          scan_timeout = 10;
          command_timeout = 80;
          custom = {
            vterm = {
              command = "vterm_prompt_end";
              when = " test ! -z $INSIDE_EMACS ";
            };
          };
        };
      };

      fish.interactiveShellInit = mkIf config.programs.fish.enable ''
        if test "$TERM" != "dumb"  -a \( -z "$INSIDE_EMACS"  -o "$INSIDE_EMACS" = "vterm" \)
          eval (${starshipCmd} init fish)
          enable_transience
        end
      '';

      zsh.initExtra = mkIf config.programs.zsh.enable ''
         if [[ $TERM != "dumb" && (-z $INSIDE_EMACS || $INSIDE_EMACS == "vterm") ]]; then
          source ${initZshPath}
          enable_transience
        fi
      '';

    };

    home.file = mkIf config.programs.zsh.enable {
      "starship.zsh" = {
        source = ./starship.zsh;
        target = "${initZshPath}";
      };
    };
  };
}
