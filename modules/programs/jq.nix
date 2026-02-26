# Module for jq configuration
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.programs.jq;
in
{
  options.modules.programs.jq = {
    enable = mkEnableOption "jq configuration";
  };

  config = mkIf cfg.enable {
    programs.jq = {
      enable = true;
    };
  };
}
