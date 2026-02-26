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
    enable = mkEnableOption "git configuration";
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      settings = {
        user.email = "daehyeok@gmail.com";
        merge.conflictstyle = "zdiff3";
      };
    };
  };
}
