{ config, pkgs, ... }:

let
  dotDir = "${config.xdg.configHome}/zsh";
in
{
  home = {
    packages = with pkgs; [
      zsh-autopair
      zsh-completions
    ];
  };
  programs = {
    zsh = {
      enableCompletion = true;
      autosuggestion = {
        enable = true;
        strategy = [
          "history"
          "completion"
        ];
      };
      fastSyntaxHighlighting.enable = true;
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

        source ${dotDir}/plugins/vterm.zsh
        source ${pkgs.zsh-autopair}/share/zsh/zsh-autopair/autopair.zsh
        fpath=(${pkgs.zsh-completions}/share/zsh/site-functions $fpath)

        # This speeds up pasting w/ autosuggest
        # https://github.com/zsh-users/zsh-autosuggestions/issues/238
        pasteinit() {
          OLD_SELF_INSERT=''${''${(s.:.)widgets[self-insert]}[2,3]}
          zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
        }

        pastefinish() {
          zle -N self-insert $OLD_SELF_INSERT
        }
        zstyle :bracketed-paste-magic paste-init pasteinit
        zstyle :bracketed-panst-magic paste-finish pastefinish
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
