# Module for delta configuration
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.programs.delta;
in
{
  options.modules.programs.delta = {
    enable = mkEnableOption "delta configuration";
  };

  config = mkIf cfg.enable {
    programs.delta = {
      enableGitIntegration = true;
      enable = true;
      options = {
        navigate = true;
        side-by-side = true;
      };
    };
    home.shellAliases.diff = "delta";
  };
}
