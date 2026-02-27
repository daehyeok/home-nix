# Module for lsd configuration
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.programs.lsd;
in
{
  options.modules.programs.lsd = {
    enable = mkEnableOption "lsd configuration";
  };

  config = mkIf cfg.enable {
    programs.lsd = {
      enable = true;
      enableBashIntegration = false;
      enableZshIntegration = true;
      enableFishIntegration = false;
      settings = {
        color = {
          when = "always";
        };
        icons = {
          when = "always";
          theme = "fancy";
        };
      };
    };

    home.shellAliases = {
      tree = "lsd --tree";
    };
  };
}
