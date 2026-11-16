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
    ./python.nix
    ./rust.nix
  ];
}
