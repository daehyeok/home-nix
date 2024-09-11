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
  cfg = devCfg.rust;
in
{
  options.modules.dev.rust = {
    enable = mkOption { default = false; };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      home.packages = [
        pkgs.rust
        pkgs.cargo
        pkgs.rust-analyzer
      ];
      # env.RUSTUP_HOME = "$XDG_DATA_HOME/rustup";
      # env.CARGO_HOME = "$XDG_DATA_HOME/cargo";
      home.sessionPath = [ "$CARGO_HOME/bin" ];
    })
  ];
}
