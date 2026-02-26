{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
{
  imports = [
    ./base
    ./dev
    ./programs
  ];
}
