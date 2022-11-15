{ config, pkgs, lib, ... }:
with lib; {
  imports = [ ./zinit.nix ./p10k.nix ./starship ./dev ./exa ];
}
