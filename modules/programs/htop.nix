# Module for htop configuration
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  config = mkIf config.programs.htop.enable {
    # Add opinionated htop defaults here if needed
  };
}
