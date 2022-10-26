{ config, pkgs, lib, ... }:
with lib;
let cfg = config.modules.dev;
in {
  imports = [ ./dart.nix ./nix.nix ./rust.nix ./kotlin.nix];
}
