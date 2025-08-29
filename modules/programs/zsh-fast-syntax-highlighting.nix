{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.zsh.fastSyntaxHighlighting;
in
{
  options.programs.zsh.fastSyntaxHighlighting = {
    enable = mkEnableOption "fast Syntax Highlighting";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.zsh-fast-syntax-highlighting ];

    programs.zsh.initContent = ''
      source ${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh
    '';

  };
}
