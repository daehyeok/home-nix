# Module for zellij configuration
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  config = mkIf config.programs.zellij.enable {
    # Add opinionated zellij defaults here if needed
  };
}
