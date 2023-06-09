{ config, pkgs, lib, ... }:
with lib; {
  imports = [ ./starship ./dev ./zinit.nix ];
}
