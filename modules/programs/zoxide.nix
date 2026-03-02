# Module for zoxide configuration
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  config = mkIf config.programs.zoxide.enable {
    # Add opinionated zoxide defaults here if needed
  };
}
