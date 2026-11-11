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

    # Agent status notifications (Rex OSC 7501). Jetski reports its own
    # lifecycle (working, blocked on permission / question / plan review /
    # sign-in / expired credentials, done, failed) when AGY_CLI_OSC7501=on.
    # agent-notify stays for what the CLI can't see (background jobs, scripts,
    # other agents) and backs the notify-user skill. The GMac links the same
    # files (home-gmac [jetski]).
    home.file.".local/bin/agent-notify" = {
      source = ./agent-notify;
      executable = true;
    };
    home.file.".gemini/config/skills/notify-user/SKILL.md".source = ./skills/notify-user/SKILL.md;

    # Force the built-in OSC 7501 status only in Rex outside tmux: "on" skips
    # Jetski's support check, so elsewhere it could print escape junk.
    programs.zsh.initContent = mkIf config.programs.zsh.enable ''
      if [[ -z "''${TMUX:-}" && ( -n "''${REX_BLOCK:-}" || "''${TERM_PROGRAM:-}" == rex ) ]]; then
        export AGY_CLI_OSC7501=on
      else
        unset AGY_CLI_OSC7501
      fi
    '';
  };
}
