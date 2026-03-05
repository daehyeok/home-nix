# Zsh configuration module
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  imports = [
    ./plugins/zsh-autopair.nix
    ./plugins/zsh-autosuggestion.nix
    ./plugins/zsh-completions.nix
    ./plugins/zsh-fast-syntax-highlighting.nix
    ./plugins/zsh-vterm
    ./emacs-editor.nix
  ];

  config = mkIf config.programs.zsh.enable {
    programs.zsh = {
      enableCompletion = mkDefault true;
      autosuggestion = {
        enable = mkDefault true;
        strategy = mkDefault [
          "history"
          "completion"
        ];
      };
      fastSyntaxHighlighting.enable = mkDefault true;
      autoPair.enable = mkDefault true;
      completionsPlugin.enable = mkDefault true;
      vterm.enable = mkDefault true;

      dotDir = mkDefault "${config.xdg.configHome}/zsh";

      history = {
        ignoreDups = mkDefault true;
        ignoreSpace = mkDefault true;
        extended = mkDefault true;
        expireDuplicatesFirst = mkDefault true;
        share = mkDefault true;
        size = mkDefault 1000;
        save = mkDefault 1000;
        path = mkDefault "${config.xdg.dataHome}/zsh/zsh_history";
      };

      sessionVariables = {
        ZSH_CACHE_DIR = "${config.xdg.cacheHome}/zsh";
        "WORDCHARS" = "''";
      };
    };
  };
}
