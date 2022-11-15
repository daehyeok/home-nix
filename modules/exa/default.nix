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
  config = mkIf (cfg.enable) {
    programs.fish.functions = {
      ls = "exa ${exa_params} {$argv}";
      l = "exa --git-ignore ${exa_params} {$argv}";
      la = "exa -a ${exa_params} {$argv}";
      ll = "exa --header --long ${exa_params} {$argv}";
      tree = "exa ${exa_params} --tree  {$argv}";
    };
  };
}
