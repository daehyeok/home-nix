{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.programs.exa;
  exa_params = concatStringsSep " " [
    "--icons"
    "--classify"
    "--group-directories-first"
    "--time-style=long-iso"
    "--group"
    "--color=auto"
  ];
in {
  config = {
    extraOptions = exa_params;
    enableAliases = true;
  };
}
