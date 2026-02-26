# Module for fzf configuration
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.programs.fzf;
in
{
  options.modules.programs.fzf = {
    enable = mkEnableOption "fzf configuration";
  };

  config = mkIf cfg.enable {
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
