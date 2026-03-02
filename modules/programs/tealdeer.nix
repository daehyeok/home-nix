# Module for tealdeer configuration
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  config = mkIf config.programs.tealdeer.enable {
    # Add opinionated tealdeer defaults here if needed
  };
}
