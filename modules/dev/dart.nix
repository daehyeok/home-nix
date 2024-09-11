{
  config,
  options,
  lib,
  pkgs,
  ...
}:

with lib;
let
  devCfg = config.modules.dev;
  cfg = devCfg.dart;
in
{
  options.modules.dev.dart = {
    enable = mkOption { default = false; };
  };

  config = mkMerge [ (mkIf cfg.enable { home.packages = [ pkgs.dart ]; }) ];
}
