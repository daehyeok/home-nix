# Module for bat configuration
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.programs.bat;
in
{
  options.modules.programs.bat = {
    enable = mkEnableOption "bat configuration";
  };

  config = mkIf cfg.enable {
    programs.bat = {
      enable = true;
    };

    home.file.".bin/cat_wrapper.sh" = {
      source = ./cat_wrapper.sh;
      executable = true;
    };

    home.shellAliases.cat = "$HOME/.bin/cat_wrapper.sh";
  };
}
