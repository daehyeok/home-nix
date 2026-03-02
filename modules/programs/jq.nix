# Module for jq configuration
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  config = mkIf config.programs.jq.enable {
    # Add opinionated jq defaults here if needed
  };
}
