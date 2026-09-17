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
    ./plugins/zsh-vterm
    ./plugins/zsh-tmux-title
    ./emacs-editor.nix
  ];

  config = mkIf config.programs.zsh.enable {
    programs.zsh = {
      enableCompletion = mkDefault true;
      completionInit = mkDefault ''
        autoload -Uz compinit
        () {
          emulate -L zsh -o extendedglob
          mkdir -p "''${ZSH_CACHE_DIR:-$HOME/.cache/zsh}"
          local zcompdump="''${ZSH_CACHE_DIR:-$HOME/.cache/zsh}/.zcompdump-$ZSH_VERSION"
          if [[ -n "$zcompdump"(#qN.mh-24) ]]; then
            compinit -C -d "$zcompdump"
          else
            compinit -d "$zcompdump"
            touch "$zcompdump"
          fi
        }
      '';
      autosuggestion = {
        enable = mkDefault true;
        strategy = mkDefault [
          "history"
        ];
      };
      fastSyntaxHighlighting.enable = mkDefault true;
      autoPair.enable = mkDefault true;
      completionsPlugin.enable = mkDefault true;
      vterm.enable = mkDefault true;
      tmuxTitle.enable = mkDefault true;

      dotDir = mkDefault "${config.xdg.configHome}/zsh";

      history = {
        ignoreDups = mkDefault true;
        ignoreSpace = mkDefault true;
        extended = mkDefault true;
        expireDuplicatesFirst = mkDefault true;
        share = mkDefault false;
        size = mkDefault 10000;
        save = mkDefault 10000;
        path = mkDefault "${config.xdg.dataHome}/zsh/zsh_history";
      };

      sessionVariables = {
        ZSH_CACHE_DIR = "${config.xdg.cacheHome}/zsh";
        "WORDCHARS" = "''";
        ZSH_AUTOSUGGEST_MANUAL_REBIND = "1";
        ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE = "20";
      };

      initContent = mkAfter ''
        if (( $+functions[_zsh_autosuggest_strategy_atuin] )); then
          ZSH_AUTOSUGGEST_STRATEGY=(history atuin)
        else
          ZSH_AUTOSUGGEST_STRATEGY=(history)
        fi
      '';
    };
  };
}
