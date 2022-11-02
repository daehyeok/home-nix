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

in {
  options = {
    programs.zinit = {
      enable = mkOption { default = false; };
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
      initExtraFirst = ''
        if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
        print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
        command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
        command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
        fi

        source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
      '';
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
  };
}
