# Module for npm configuration
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  npmGlobalDir = "${config.home.homeDirectory}/.local/share/npm-global";
in
{
  config = mkIf config.programs.npm.enable {
    programs.npm = {
      settings = {
        prefix = mkDefault npmGlobalDir;
      };
    };

    home.sessionPath = [
      "${npmGlobalDir}/bin"
    ];

    programs.zsh.initContent = mkIf config.programs.zsh.enable (mkAfter ''
      path+=("${npmGlobalDir}/bin")
    '');
  };
}
