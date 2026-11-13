{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.antigravity;
  # rex-agy-subagent (panel, hook): pinned; bump rev to update.
  rexAgySubagent = builtins.fetchGit {
    url = "ssh://git@github.com/daehyeok/rex-agy-subagent";
    ref = "main";
    rev = "46f25e23dc0fafa3372b23acacab34073b056140";
  };
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

    # Subagent panel (rex-agy-subagent): a PostToolUse hook on invoke_subagent opens a
    # read-only Rex floating panel listing the session's subagents, rebuilt from the
    # transcripts; PREFIX j s shows/hides/reopens it (GMac Rex config). The panel config
    # sets the Jetski data dir and the pager. The hook never reports agent status; that
    # stays with the built-in OSC 7501 above.
    # The scripts find their Python modules next to themselves in the pinned checkout.
    home.file.".gemini/config/hooks.json".source = ./hooks.json;
    home.file.".config/rex-agy-subagent/config.json".source = ./rex-agy-subagent.json;
    home.file.".local/bin/agy-subagent".source = "${rexAgySubagent}/bin/agy-subagent";
    home.file.".local/bin/agy-subagent-hook".source = "${rexAgySubagent}/bin/agy-subagent-hook";

    # Force the built-in OSC 7501 status only in Rex outside tmux: "on" skips
    # Jetski's support check, so elsewhere it could print escape junk.
    # "brief" leaves the reply / pending command / question text out of the
    # status (raw markdown reads badly in banners).
    programs.zsh.initContent = mkIf config.programs.zsh.enable ''
      if [[ -z "''${TMUX:-}" && ( -n "''${REX_BLOCK:-}" || "''${TERM_PROGRAM:-}" == rex ) ]]; then
        export AGY_CLI_OSC7501=on AGY_CLI_OSC7501_MESSAGES=brief
      else
        unset AGY_CLI_OSC7501 AGY_CLI_OSC7501_MESSAGES
      fi
    '';
  };
}
