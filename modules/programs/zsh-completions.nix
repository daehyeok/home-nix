{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.zsh.completionsPlugin;
in
{
  options.programs.zsh.completionsPlugin = {
    enable = mkEnableOption "Enable zsh-completions plugin.";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.zsh-completions ];
    programs.zsh.initExtraFirst = ''
      fpath=(${pkgs.zsh-completions}/share/zsh/site-functions $fpath)
    '';

  };
}
