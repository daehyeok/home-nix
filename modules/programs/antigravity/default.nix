{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.antigravity;
in
{
  disabledModules = [ "programs/antigravity.nix" ];

  options.programs.antigravity = {
    enable = mkEnableOption "antigravity";
    cliDir = mkOption {
      type = types.str;
      default = ".gemini/antigravity-cli";
      description = "Directory relative to $HOME where Antigravity/Jetski CLI scripts are linked.";
    };
    profiles = mkOption {
      type = types.attrsOf types.anything;
      default = { };
      internal = true;
      description = "Unused stub for compatibility with catppuccin vscode module.";
    };
  };

  config = mkIf cfg.enable {
    home.file."${cfg.cliDir}/statusline.sh" = {
      source = ./statusline.sh;
      executable = true;
    };
    home.file."${cfg.cliDir}/window_title.sh" = {
      source = ./window_title.sh;
      executable = true;
    };
  };
}
