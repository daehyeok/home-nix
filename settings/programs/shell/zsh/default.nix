{ config, pkgs, ... }:

let dotDir = "${config.xdg.configHome}/zsh";
in {
  programs = {
    zinit = {
      plugins = [
        {
          repo = "zpm-zsh/ls";
          initExtra = "export ZSH_LS_DISABLE_GIT=true";
        }
        { repo = "hlissner/zsh-autopair"; }
        { repo = "zdharma-continuum/fast-syntax-highlighting"; }
        { repo = "changyuheng/zsh-interactive-cd"; }
        {
          repo = "zsh-users/zsh-autosuggestions";
          initExtraFirst = ''
            ZSH_AUTOSUGGEST_STRATEGY=(history completion)
            ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
            ZSH_AUTOSUGGEST_MANUAL_REBIND=1
            ZSH_AUTOSUGGEST_USE_ASYNC=1'';
        }
        { repo = "mfaerevaag/wd"; }
        { repo = "Aloxaf/gencomp"; }
      ];
      snippets = [
        { url = "OMZL::completion.zsh"; }
        { url = "OMZP::safe-paste"; }

        { url = "${dotDir}/vterm.zsh"; }
      ];
    };
    zsh = {
      enableCompletion = true;
      dotDir = ".config/zsh";
      history = {
        ignoreDups = true;
        ignoreSpace = true;
        share = true;
        size = 1000;
        save = 1000;
        path = "${config.xdg.dataHome}/zsh/zsh_history";
      };
      initExtra = ''
        [[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
      '';
      sessionVariables = {
        ZSH_CACHE_DIR = "${config.xdg.cacheHome}/zsh";
        "WORDCHARS" = "''";
      };
      shellAliases = {
        diff = "delta";
        cat = "bat --plain";
        tree = "exa --tree";
      };
    };
  };

  home.file = {
    "vterm.zsh" = {
      source = ./vterm.zsh;
      target = "${dotDir}/vterm.zsh";
    };
  };
}
