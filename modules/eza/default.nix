{
  config,
  lib,
  pkgs,
  ...
}:
with lib;

let
  cfg = config.programs.eza;
  eza_params = concatStringsSep " " [
    "--icons"
    "--classify"
    "--group-directories-first"
    "--time-style=long-iso"
    "--group"
    "--color=auto"
  ];
in
{
  config = {
    extraOptions = eza_params;
    enableZshIntegration = true;
  };
}
