{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.zinit;
  packModule = types.submodule ({ config, ... }: {
    options = { name = mkOption { type = types.str; }; };
  });
  zinitPackStr = concatStrings (map (item: ''
    zinit pack for ${item.name}
  '') cfg.packs);
  pluginModule = types.submodule ({ config, ... }: {
    options = {
      repo = mkOption { type = types.str; };
      initExtra = mkOption {
        type = types.str;
        default = "";
      };
      initExtraFirst = mkOption {
        type = types.str;
        default = "";
      };
    };
  });
  zinitPluginStr = concatStrings (map (item: ''
    ${item.initExtraFirst}
    zinit ice depth"1"
    zinit light ${item.repo}
    ${item.initExtra}
  '') cfg.plugins);
  zinitCompletionStr = concatStrings (map (item: ''
    zinit ice as'completion' depth"1"
    zinit light ${item}
  '') cfg.completions);

  snippetModule = types.submodule
    ({ config, ... }: { options = { url = mkOption { type = types.str; }; }; });
  zinitSnippetStr = concatStrings (map (item: ''
    zinit snippet ${item.url}
  '') cfg.snippets);

  zinitSetupStr = ''
    if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
    print -P "%F{33} %F{34}Installation successful.%f%b" || \
    print -P "%F{160} The clone has failed.%f%b"
    fi
    source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
  '';

  # Variables for overwrite .zshrc
  zshcfg = config.programs.zsh;
  aliasesStr = concatStringsSep "\n"
    (mapAttrsToList (k: v: "alias ${k}=${lib.escapeShellArg v}")
      zshcfg.shellAliases);

  globalAliasesStr = concatStringsSep "\n"
    (mapAttrsToList (k: v: "alias -g ${k}=${lib.escapeShellArg v}")
      zshcfg.shellGlobalAliases);

  dirHashesStr = concatStringsSep "\n"
    (mapAttrsToList (k: v: ''hash -d ${k}="${v}"'') zshcfg.dirHashes);

  localVarsStr = config.lib.zsh.defineAll zshcfg.localVariables;

in {
  options = {
    programs.zinit = {
      enable = mkOption { default = false; };
      useCustomZshrc = mkOption { default = false; };
      packs = mkOption {
        type = types.listOf packModule;
        default = [ ];
      };
      plugins = mkOption {
        type = types.listOf pluginModule;
        default = [ ];
      };
      completions = mkOption {
        type = types.listOf types.str;
        default = [ ];
      };
      snippets = mkOption {
        type = types.listOf snippetModule;
        default = [ ];
      };
    };
  };

  config = mkIf cfg.enable {
    programs.zsh = {
      initExtraFirst = mkIf (!cfg.useCustomZshrc) "${zinitSetupStr}";
      completionInit = ''
        autoload -Uz _zinit
        (( ''${+_comps} )) && _comps[zinit]=_zinit'';
      initExtra = mkOrder 100 ''
        # Load a few important annexes, without Turbo
        # (this is currently required for annexes)
        zinit light-mode for \
        zdharma-continuum/zinit-annex-as-monitor \
        zdharma-continuum/zinit-annex-bin-gem-node \
        zdharma-continuum/zinit-annex-patch-dl \
        zdharma-continuum/zinit-annex-rust
        ${zinitPackStr}
        ${zinitPluginStr}
        ${zinitCompletionStr}
        ${zinitSnippetStr}

      '';
    };

    home.packages = with pkgs; [ zsh ];
    home.file = mkIf cfg.useCustomZshrc {
      ".config/zsh/.zshrc" = lib.mkOverride 50 {
        text = ''
          ${zshcfg.initExtraFirst}

          typeset -U path cdpath fpath manpath

          for profile in ''${(z)NIX_PROFILES}; do
            fpath+=($profile/share/zsh/site-functions $profile/share/zsh/$ZSH_VERSION/functions $profile/share/zsh/vendor-completions)
          done

          if [[ ! -f "$HOME/.local/share/zinit/zinit.git/zinit.zsh" ]]; then
          print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
          command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
          command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
          print -P "%F{33} %F{34}Installation successful.%f%b" || \
          print -P "%F{160} The clone has failed.%f%b"
          fi

          source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"

          ${zshcfg.completionInit}

          HELPDIR="${pkgs.zsh}/share/zsh/$ZSH_VERSION/help"

          ${localVarsStr}
          ${zshcfg.initExtraBeforeCompInit}

          HISTSIZE="${toString zshcfg.history.size}"
          SAVEHIST="${toString zshcfg.history.save}"
          ${optionalString (zshcfg.history.ignorePatterns != [ ])
          "HISTORY_IGNORE=${
            lib.escapeShellArg
            "(${lib.concatStringsSep "|" zshcfg.history.ignorePatterns})"
          }"}
          ${if versionAtLeast config.home.stateVersion "20.03" then
            ''HISTFILE="${zshcfg.history.path}"''
          else
            ''HISTFILE="$HOME/${zshcfg.history.path}"''}
          mkdir -p "$(dirname "$HISTFILE")"
          setopt HIST_FCNTL_LOCK
          ${
            if zshcfg.history.ignoreDups then "setopt" else "unsetopt"
          } HIST_IGNORE_DUPS
          ${
            if zshcfg.history.ignoreSpace then "setopt" else "unsetopt"
          } HIST_IGNORE_SPACE
          ${
            if zshcfg.history.expireDuplicatesFirst then
              "setopt"
            else
              "unsetopt"
          } HIST_EXPIRE_DUPS_FIRST
          ${if zshcfg.history.share then "setopt" else "unsetopt"} SHARE_HISTORY
          ${
            if zshcfg.history.extended then "setopt" else "unsetopt"
          } EXTENDED_HISTORY
          ${if zshcfg.autocd != null then
            "${if zshcfg.autocd then "setopt" else "unsetopt"} autocd"
          else
            ""}

          ${zshcfg.initExtra}
          # Aliases
          ${aliasesStr}
          # Global Aliases
          ${globalAliasesStr}
          # Named Directory Hashes
          ${dirHashesStr}
        '';
      };
    };
  };

}
