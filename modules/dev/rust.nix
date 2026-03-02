{
  config,
  options,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.dev.rust;
in
{
  options.modules.dev.rust = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable rust development environment";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.rust
      pkgs.cargo
      pkgs.rust-analyzer
    ];
    home.sessionPath = [ "$CARGO_HOME/bin" ];
  };
}
