# Module for eza configuration
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.programs.eza;
in
{
  options.modules.programs.eza = {
    enable = mkEnableOption "eza configuration";
  };

  config = mkIf cfg.enable {
    programs.eza = {
      enable = true;
      enableZshIntegration = true;
      extraOptions = [
        "--classify"
        "--group-directories-first"
        "--time-style=long-iso"
        "--group"
        "--color=auto"
      ];
      icons = "auto";
    };
    home.shellAliases.tree = "eza --tree";
  };
}
