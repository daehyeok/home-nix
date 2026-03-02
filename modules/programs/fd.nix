# Module for fd configuration
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  config = mkIf config.programs.fd.enable {
    # Add opinionated fd defaults here if needed
  };
}
