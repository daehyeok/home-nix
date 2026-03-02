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
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable delta configuration";
    };
  };

  config = mkIf cfg.enable {
    programs.delta = {
      enable = mkDefault true;
      enableGitIntegration = true;
      options = {
        navigate = true;
        side-by-side = true;
      };
    };
    home.shellAliases.diff = "delta";
  };
}
