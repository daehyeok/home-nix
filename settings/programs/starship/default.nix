{ config, lib, pkgs, ... }:
let initZshPath = "${config.xdg.configHome}/starship/starship.zsh";
in {

  programs = {
    starship = {
      #use patchec zsh init script for transience untill PR is merged
      #https://github.com/starship/starship/pull/4205
      enableZshIntegration = false;
      settings = {
        add_newline = false;

        format =
          " $username$hostname$directory$git_branch$git_state$character";

        character = {
          success_symbol = "[❯](fg:76)";
          error_symbol = "[❯](fg:196)";
          vimcmd_symbol = "[V]";
        };

        directory = {
          style = "bold fg:39";
          truncation_symbol = "//.../";
          repo_root_style = "bold yellow";
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
