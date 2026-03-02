# Module for ripgrep configuration
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  config = mkIf config.programs.ripgrep.enable {
    # Add opinionated ripgrep defaults here if needed
  };
}
