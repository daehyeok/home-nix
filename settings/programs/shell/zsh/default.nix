{ config, pkgs, ... }:

let dotDir = "${config.xdg.configHome}/zsh";
in {
    home = {
      packages = with pkgs; [ zsh-fast-syntax-highlighting
                              zsh-autopair
                              zsh-completions
                            ];
    };
  programs = {        
    zsh = {
      enableCompletion = true;
      autosuggestion.enable = true;
      dotDir = ".config/zsh";

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
      #TODO   { url = "OMZP::safe-paste"; }
      initExtra = ''
        [[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

        ZSH_AUTOSUGGEST_STRATEGY=(history completion)
        ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
        ZSH_AUTOSUGGEST_MANUAL_REBIND=1
        ZSH_AUTOSUGGEST_USE_ASYNC=1

        source ${dotDir}/plugins/vterm.zsh
        source ${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh
        source ${pkgs.zsh-autopair}/share/zsh/zsh-autopair/autopair.zsh
        fpath=(${pkgs.zsh-completions}/share/zsh/site-functions $fpath)
        '';
      sessionVariables = {
        ZSH_CACHE_DIR = "${config.xdg.cacheHome}/zsh";
        "WORDCHARS" = "''";
      };
      shellAliases = {
        diff = "delta";
        cat = "bat --plain";
        tree = "eza --tree";
      };
    };
  };

  home.file = {
    "vterm.zsh" = {
      source = ./vterm.zsh;
      target = "${dotDir}/plugins/vterm.zsh";
    };
  };
}
