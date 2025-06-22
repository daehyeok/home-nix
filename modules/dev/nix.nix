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
  cfg = devCfg.nix;
in
{
  options.modules.dev.nix = {
    enable = mkOption { default = false; };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      home.packages = [
        pkgs.nil
        pkgs.nixfmt-rfc-style
      ];
    })
  ];
}
