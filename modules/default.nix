{ config, pkgs, lib, ... }:
with lib; {
  imports = [ ./env.nix ./zinit.nix ./p10k.nix ./starship ./dev ];
}
