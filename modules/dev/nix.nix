{
  config,
  options,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.dev.nix;
in
{
  options.modules.dev.nix = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable nix development environment";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.nil
      pkgs.nixfmt
    ];
  };
}
