# Module for lsd configuration
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  config = mkIf config.programs.lsd.enable {
    programs.lsd = {
      enableBashIntegration = mkDefault false;
      enableZshIntegration = mkDefault true;
      enableFishIntegration = mkDefault false;
      settings = {
        color = mkDefault {
          when = "always";
        };
        sorting.dir-grouping = "first";
        icons = mkDefault {
          when = "always";
          theme = "fancy";
        };
      };
    };

    home.shellAliases = {
      tree = mkDefault "lsd --tree";
    };
  };
}
