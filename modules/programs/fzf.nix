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
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable fzf configuration";
    };
  };

  config = mkIf cfg.enable {
    programs.fzf = {
      enable = mkDefault true;
      enableZshIntegration = true;
    };
  };
}
