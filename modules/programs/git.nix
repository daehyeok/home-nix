# Module for git configuration
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  config = mkIf config.programs.git.enable {
    programs.git = {
      settings = {
        user.email = mkDefault "daehyeok@gmail.com";
        merge.conflictstyle = mkDefault "zdiff3";
      };
    };
  };
}
