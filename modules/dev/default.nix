{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.modules.dev;
in
{
  imports = [
    ./nix.nix
    ./rust.nix
  ];
}
