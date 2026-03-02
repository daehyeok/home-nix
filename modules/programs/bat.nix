# Module for bat configuration
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  config = mkIf config.programs.bat.enable {
    home.shellAliases.cat = "${pkgs.writeShellScript "cat-wrapper" (builtins.readFile ./cat_wrapper.sh)}";
  };
}
