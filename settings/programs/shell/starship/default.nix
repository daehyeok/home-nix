{ config, lib, pkgs, ... }:
let initZshPath = "${config.xdg.configHome}/starship/starship.zsh";
in {

  programs = {
    starship = {
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
      };
    };
  };
}
