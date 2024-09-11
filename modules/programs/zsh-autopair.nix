{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.zsh.autoPair;
in
{
  options.programs.zsh.autoPair = {
    enable = mkEnableOption "Enable zsh-autopair plugin.";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.zsh-autopair ];
    programs.zsh.initExtra = ''
      source ${pkgs.zsh-autopair}/share/zsh/zsh-autopair/autopair.zsh
    '';

  };
}
