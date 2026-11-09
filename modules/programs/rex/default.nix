# Rex terminal multiplexer (https://www.superlogical.com/rex/docs).
#
# Imports the upstream home-manager module from Rex's prebuilt flake, which
# provides:
#   * programs.rex  - CLI, xterm-rex terminfo, ssh guard, ~/.config/rex/init.lua
#   * services.rex  - personal server as a systemd user service (Linux only)
# Enable them per host (home.nix / mac_home.nix).
#
# Pinned to an immutable release URL so switches are reproducible. To upgrade,
# pick the newest release from the `Link: rel="immutable"` header of:
#   curl -sI https://pkgs.superlogical.com/rex/nix/preview.tar.gz
# (channels: stable, preview, snapshot; stable has no releases yet).
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  rex = builtins.getFlake "https://pkgs.superlogical.com/rex/nix/preview/0.1.0-preview.13.tar.gz";
  cfg = config.programs.rex;
in
{
  imports = [ rex.homeManagerModules.default ];

  config = mkIf cfg.enable {
    # Shared ~/.config/rex/init.lua for every host.
    programs.rex.config = mkDefault ./init.lua;

    # On macOS the Rex app ships its own `rex` CLI; only manage config there.
    # (terminfo and sshGuard default to off when package is null; run
    # `rex terminfo setup` on the Mac instead.)
    programs.rex.package = mkIf pkgs.stdenv.hostPlatform.isDarwin (mkDefault null);

    # init.lua ends with `require("local")` for unmanaged per-host overrides.
    # Create an empty ~/.config/rex/local.lua on switch if it doesn't exist
    # (never overwrite an existing one).
    home.activation.rexLocalConfig = hm.dag.entryAfter [ "writeBoundary" ] ''
      rexLocal="${config.xdg.configHome}/rex/local.lua"
      if [ ! -e "$rexLocal" ]; then
        run mkdir -p "$(dirname "$rexLocal")"
        run touch "$rexLocal"
      fi
    '';

    # The ssh guard is added through programs.ssh, which home-manager only
    # writes when enabled. Keep ssh behavior otherwise unchanged.
    programs.ssh = mkIf cfg.sshGuard {
      enable = mkDefault true;
      enableDefaultConfig = mkDefault false;
    };
  };
}
