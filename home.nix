# Main Home Manager configuration entry point
{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
{
  imports = [
    ./modules
    ./settings
    <catppuccin/modules/home-manager>
  ];
}
