# Module for atuin configuration
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  config = mkIf config.programs.atuin.enable {
    # Add opinionated atuin defaults here if needed
  };
}
