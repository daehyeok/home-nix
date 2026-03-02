# Module for fzf configuration
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  config = mkIf config.programs.fzf.enable {
    programs.fzf = {
      enableZshIntegration = mkDefault true;
    };
  };
}
