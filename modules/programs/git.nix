# Module for git configuration
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.programs.git;
in
{
  options.modules.programs.git = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable git configuration";
    };
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = mkDefault true;
      settings = {
        user.email = "daehyeok@gmail.com";
        merge.conflictstyle = "zdiff3";
      };
    };
  };
}
