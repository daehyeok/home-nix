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
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable starship configuration";
      };
      transientPrompt = mkOption {
        type = types.bool;
        default = true;
        description = "Enable transient prompt";
      };
    };
  };

  config = mkIf cfg.enable {
    programs = {
      starship = {
        enable = mkDefault true;
        enableZshIntegration = false;
        settings = {
          add_newline = false;

          format = " $directory$character";

          character = {
            success_symbol = "[❯](fg:76)";
            error_symbol = "[❯](fg:196)";
          };

          directory = {
            style = "bold fg:39";
            truncation_symbol = "//.../";
            truncate_to_repo = false;
            # repo_root_style = "bold yellow";
          };

          git_branch = {
            format = "[$symbol$branch(:$remote_branch)](fg:76)";
            symbol = "";
          };

          git_state = {
            format = "([$state( $progress_current/$progress_total)]($style)) ";
            style = "bright-black";
          };

          time.disabled = false;
          package.disabled = true;

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

      zsh.initContent = mkIf config.programs.zsh.enable ''
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
