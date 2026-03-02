# Starship configuration module
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.programs.starship;
  initZshPath = "${config.xdg.configHome}/starship/starship.zsh";
in
{
  options = {
    modules.programs.starship = {
      transientPrompt = mkOption {
        type = types.bool;
        default = true;
        description = "Enable transient prompt";
      };
    };
  };

  config = mkIf config.programs.starship.enable {
    programs = {
      starship = {
        enableZshIntegration = mkDefault false;
        settings = {
          add_newline = mkDefault false;

          format = mkDefault " $directory$character";

          character = {
            success_symbol = mkDefault "[❯](fg:76)";
            error_symbol = mkDefault "[❯](fg:196)";
          };

          directory = {
            style = mkDefault "bold fg:39";
            truncation_symbol = mkDefault "//.../";
            truncate_to_repo = mkDefault false;
          };

          git_branch = {
            format = mkDefault "[$symbol$branch(:$remote_branch)](fg:76)";
            symbol = mkDefault "";
          };

          git_state = {
            format = mkDefault "([$state( $progress_current/$progress_total)]($style)) ";
            style = mkDefault "bright-black";
          };

          time.disabled = mkDefault false;
          package.disabled = mkDefault true;

          scan_timeout = mkDefault 10;
          command_timeout = mkDefault 80;
          custom = {
            vterm = {
              command = "vterm_prompt_end";
              when = " test ! -z $INSIDE_EMACS ";
            };
          };
        };
      };

      zsh.initContent = mkIf config.programs.zsh.enable ''
        if [[ $TERM != "dumb" && (-z $INSIDE_EMACS || $INSIDE_EMACS == "vterm") ]]; then
          source ${initZshPath}
          ${optionalString cfg.transientPrompt "enable_transience"}
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
