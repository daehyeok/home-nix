{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.programs.zsh.vterm;
  zshVetermSh = ".vterm.zsh";
  zshVtermFilePath = "${config.programs.zsh.dotDir}/${zshVetermSh}";
in
{
  options.programs.zsh.vterm = {
    enable = mkEnableOption "Add emacs vterm scripts..";
  };

  config = mkIf cfg.enable {
    home.file = {
      "vterm.zsh" = {
        source = ./vterm.zsh;
        target = "${zshVtermFilePath}";
      };
    };

    programs.zsh.initExtra = ''
      source ~/${zshVtermFilePath}
    '';

  };
}
