{ config, pkgs, lib, ... }: with lib; { imports = [ ./env.nix ./zinit.nix  ./dev]; }
