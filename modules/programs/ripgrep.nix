# Module for ripgrep configuration
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.programs.ripgrep;
in
{
  options.modules.programs.ripgrep = {
    enable = mkEnableOption "ripgrep configuration";
  };

  config = mkIf cfg.enable {
    programs.ripgrep = {
      enable = true;
    };
  };
}
