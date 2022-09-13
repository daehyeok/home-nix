{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    zsh-autopair
    zsh-autosuggestions
    zsh-powerlevel10k
    zsh-fast-syntax-highlighting
  ];
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    dotDir = ".config/zsh";
    history = {
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
      size = 3000;
    };
    plugins = with pkgs; [
      {
        name = "ls";
        src = pkgs.fetchFromGitHub {
          owner = "zpm-zsh";
          repo = "ls";
          rev = "4c93ff4f13116a2260eb5f4bd77dfc62092f2d35";
          sha256 = "/Z6e5YuIwwPABuNOTXVzVnoSP2hzEP32d/M0kJypwAk=";
        };
      }
      {
        name = "powerlevel10k";
        file = "powerlevel10k.zsh-theme";
        src = "${zsh-powerlevel10k}/share/zsh-powerlevel10k";
      }
      {
        name = "zsh-autopair";
        file = "zsh-autopair.zsh";
        src = "${zsh-autopair}/share/zsh/zsh-autopair";
      }
      {
        name = "fast-syntax-highlighting";
        file = "fast-syntax-highlighting.plugin.zsh";
        src = "${zsh-fast-syntax-highlighting}/share/zsh/site-functions";
      }
      {
        name = "wd";
        src = pkgs.fetchFromGitHub {
          owner = "mfaerevaag";
          repo = "wd";
          rev = "eaf39c0b8a0b3b99fa5f0904612f2230c5f20634";
          sha256 = "UWA3AMNZW5WYRAy7ebi6CLTjxnu/tuddY2sUXMbsFkY=";
        };
      }
      {
        name = "zsh-interactive-cd";
        src = pkgs.fetchFromGitHub {
          owner = "changyuheng";
          repo = "zsh-interactive-cd";
          rev = "7bbe02e9444cf335beab1cc27f957d799ae89dab";
          sha256 = "jqWkCT9IyL+inOyxCGQlFezJ1boiB46frjKpBljQJyc=";
        };
      }
    ];
    initExtraFirst = ''
      P10K_INSTANT_PROMPT="${config.xdg.cacheHome}/p10k-instant-prompt-''${(%):-%n}.zsh"
      [[ ! -r "$P10K_INSTANT_PROMPT" ]] || source "$P10K_INSTANT_PROMPT"
      [[ ! -f "${config.xdg.configHome}/zsh/p10k_work.zsh" ]] || source ${config.xdg.configHome}/zsh/p10k_work.zsh
      [[ ! -f "${config.xdg.configHome}/zsh/p10k.zsh" ]] || source ${config.xdg.configHome}/zsh/p10k.zsh
    '';
    initExtra = ''
      # auto compleition setup to selec menu with emacs move key binding
      zmodload -i zsh/complist
      unsetopt menu_complete   # do not autoselect the first completion entry
      unsetopt flowcontrol
      setopt auto_menu         # show completion menu on successive tab press
      setopt complete_in_word
      setopt always_to_end
      zstyle ':completion:*:*:*:*:*' menu select
      zstyle ':completion:*' list-colors \'\'

      # disable named-directories autocompletion
      zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
      zstyle ':completion:*:ssh:*' hosts off

      # Use caching so that commands like apt and dpkg complete are useable
      zstyle ':completion:*' use-cache yes
      zstyle ':completion:*' cache-path $ZSH_CACHE_DIR

      # ... unless we really want to.
      zstyle '*' single-ignored show

      WORDCHARS=\'\'
      [[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
      path+=("$HOME/.config/emacs/bin")
      path+=("$HOME/.bin")
    '' + builtins.readFile ./vterm.zsh;
    sessionVariables = {
      "TERMINFO_DIRS" =
        "$HOME/.nix-profile/share/terminfo:/etc/terminfo:/lib/terminfo:/usr/share/terminfo";
      "ZSH_CACHE_DIR" = "${config.xdg.cacheHome}/zsh";
      "ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE" = 20;
      "ZSH_AUTOSUGGEST_MANUAL_REBIND" = 1;
    };
    shellAliases = {
      diff = "delta";
      cat = "bat --plain";
      tree = "exa --tree";
    };
  };

  home.file = {
    "p10k.zsh" = {
      source = ./p10k.zsh;
      target = ".config/zsh/p10k.zsh";
    };
  };
}
