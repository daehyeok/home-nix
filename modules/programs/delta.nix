# Module for delta configuration
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  config = mkIf config.programs.delta.enable {
    programs.delta = {
      enableGitIntegration = mkDefault true;
      options = {
        navigate = mkDefault true;
        side-by-side = mkDefault true;
      };
    };
    home.shellAliases.diff = mkDefault "delta";
  };
}
