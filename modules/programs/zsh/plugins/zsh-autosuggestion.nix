{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.zsh.autosuggestion;
in
{
  config = mkIf cfg.enable {
    programs.zsh.initContent = ''
      # This speeds up pasting w/ autosuggest
      # https://github.com/zsh-users/zsh-autosuggestions/issues/238
      autoload -Uz url-quote-magic
      pasteinit() {
        OLD_SELF_INSERT=''${''${(s.:.)widgets[self-insert]}[2,3]}
        zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
      }

      pastefinish() {
        zle -N self-insert $OLD_SELF_INSERT
      }
      zstyle :bracketed-paste-magic paste-init pasteinit
      zstyle :bracketed-paste-magic paste-finish pastefinish
    '';

  };
}
