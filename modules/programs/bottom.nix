# Module for bottom configuration
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  config = mkIf config.programs.bottom.enable {
    # Add opinionated bottom defaults here if needed
  };
}
