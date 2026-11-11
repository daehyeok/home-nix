{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.antigravity;
in
{
  disabledModules = [ "programs/antigravity.nix" ];

  options.programs.antigravity = {
    enable = mkEnableOption "antigravity";
    cliDir = mkOption {
      type = types.str;
      default = ".gemini/antigravity-cli";
      description = "Directory relative to $HOME where Antigravity/Jetski CLI scripts are linked.";
    };
    profiles = mkOption {
      type = types.attrsOf types.anything;
      default = { };
      internal = true;
      description = "Unused stub for compatibility with catppuccin vscode module.";
    };
  };

  config = mkIf cfg.enable {
    home.file."${cfg.cliDir}/statusline.sh" = {
      source = ./statusline.sh;
      executable = true;
    };
    # Shared path compression (same as zsh tab titles), used by window_title.sh.
    home.file."${cfg.cliDir}/compress_path.sh".source = ../tmux/compress_path.sh;
    home.file."${cfg.cliDir}/window_title.sh" = {
      source = ./window_title.sh;
      executable = true;
    };

    # Agent status notifications (Rex OSC 7501): agent-notify is the one
    # emitter (also used by the notify-user skill and scripts); Jetski hooks
    # report working / blocked (ask_question) / done (with a summary) through
    # jetski-notify-hook. The GMac links the same files (home-gmac [jetski]).
    home.file.".local/bin/agent-notify" = {
      source = ./agent-notify;
      executable = true;
    };
    home.file."${cfg.cliDir}/jetski-notify-hook" = {
      source = ./jetski-notify-hook;
      executable = true;
    };
    home.file.".gemini/config/hooks.json".source = ./hooks.json;
    home.file.".gemini/config/skills/notify-user/SKILL.md".source = ./skills/notify-user/SKILL.md;
  };
}
