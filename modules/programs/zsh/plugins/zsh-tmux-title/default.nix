{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.programs.zsh.tmuxTitle;
  zshTmuxTitleSh = ".tmux-title.zsh";
  zshTmuxTitleFilePath = "${config.programs.zsh.dotDir}/${zshTmuxTitleSh}";
in
{
  options.programs.zsh.tmuxTitle = {
    enable = mkEnableOption "Enable Zsh hooks for tmux window titles and path compression.";
  };

  config = mkIf cfg.enable {
    home.file = {
      "compress_path.sh" = {
        source = ../../../tmux/compress_path.sh;
        target = "${config.programs.zsh.dotDir}/.compress_path.sh";
      };
      "tmux-title.zsh" = {
        source = ./tmux-title.zsh;
        target = "${zshTmuxTitleFilePath}";
      };
    };

    programs.zsh.initContent = ''
      source ${zshTmuxTitleFilePath}
    '';
  };
}
