{ config, options, lib, pkgs, ... }:

with lib;
let
  devCfg = config.modules.dev;
  cfg = devCfg.kotlin;
in {
  options.modules.dev.kotlin = { enable = mkOption { default = false; }; };

  config = mkMerge [ (mkIf cfg.enable { home.packages = [ ]; }) ];
}
