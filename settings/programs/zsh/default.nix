{ config, pkgs, ... }:

let dotDir = "${config.xdg.configHome}/zsh";
in {
  programs = {
    zinit = {
      enable = true;
      plugins = [
        {
          repo = "zpm-zsh/ls";
          initExtra = "export ZSH_LS_DISABLE_GIT=true";
        }
        { repo = "hlissner/zsh-autopair"; }
        { repo = "zdharma-continuum/fast-syntax-highlighting"; }
        { repo = "changyuheng/zsh-interactive-cd"; }
        { repo = "zsh-users/zsh-autosuggestions"; }
        { repo = "mfaerevaag/wd"; }
        {
          repo = "romkatv/powerlevel10k";
          initExtra = ''
            [[ ! -f "${dotDir}/p10k_work.zsh" ]] || zinit snippet ${dotDir}/p10k_work.zsh
            [[ ! -f "${dotDir}/p10k.zsh" ]] || zinit snippet  ${dotDir}/p10k.zsh
          '';
        }
      ];
      snippets = [{ url = "OMZL::completion.zsh"; }];
    };
    zsh = {
      enable = true;
      enableCompletion = true;
      dotDir = ".config/zsh";
      history = {
        ignoreDups = true;
        ignoreSpace = true;
        share = true;
        size = 3000;
      };
      initExtraFirst = ''
        P10K_INSTANT_PROMPT="${config.xdg.cacheHome}/p10k-instant-prompt-''${(%):-%n}.zsh"
        [[ ! -r "$P10K_INSTANT_PROMPT" ]] || source "$P10K_INSTANT_PROMPT"
      '';
      initExtra = ''
        [[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
        path+=("$HOME/.config/emacs/bin")
        path+=("$HOME/.bin")
      '';
      sessionVariables = {
        "TERMINFO_DIRS" =
          "$HOME/.nix-profile/share/terminfo:/etc/terminfo:/lib/terminfo:/usr/share/terminfo";
        "ZSH_CACHE_DIR" = "${config.xdg.cacheHome}/zsh";
        "ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE" = 20;
        "ZSH_AUTOSUGGEST_MANUAL_REBIND" = 1;
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
    "p10k.zsh" = {
      source = ./p10k.zsh;
      target = "${dotDir}/p10k.zsh";
    };
    "vterm.zsh" = {
      source = ./vterm.zsh;
      target = "${dotDir}/vterm.zsh";
    };
  };
}
