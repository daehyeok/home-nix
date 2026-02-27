{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
{
  imports = [
    ./dev
    ./programs
  ];
}
