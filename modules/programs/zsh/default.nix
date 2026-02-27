# Zsh configuration module
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.programs.zsh;
in
{
  imports = [
    ./plugins/zsh-autopair.nix
    ./plugins/zsh-autosuggestion.nix
    ./plugins/zsh-completions.nix
    ./plugins/zsh-fast-syntax-highlighting.nix
    ./plugins/zsh-vterm
  ];

  options.modules.programs.zsh = {
    enable = mkEnableOption "zsh configuration";
  };

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion = {
        enable = true;
        strategy = [
          "history"
          "completion"
        ];
      };
      fastSyntaxHighlighting.enable = lib.mkDefault true;
      autoPair.enable = true;
      completionsPlugin.enable = true;
      vterm.enable = true;

      dotDir = "${config.xdg.configHome}/zsh";

      history = {
        ignoreDups = true;
        ignoreSpace = true;
        extended = true;
        expireDuplicatesFirst = true;
        share = true;
        size = 1000;
        save = 1000;
        path = "${config.xdg.dataHome}/zsh/zsh_history";
      };

      sessionVariables = {
        ZSH_CACHE_DIR = "${config.xdg.cacheHome}/zsh";
        "WORDCHARS" = "''";
      };
    };
  };
}
