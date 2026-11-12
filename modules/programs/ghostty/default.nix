# Ghostty config (macOS only), link-only. Import from mac_home.nix only:
# modules/programs/default.nix is shared with gLinux and the Pi.
#
# Ghostty may be installed outside Nix (official download or Homebrew cask), so
# this module installs nothing and doesn't use HM's programs.ghostty (that writes
# a read-only store copy). It only links ~/.config/ghostty/config.ghostty to the
# home-nix checkout (out-of-store, so edits land in the checkout as a git diff).
# The GMac links the same file from the dotfiles nix/common submodule
# (home-gmac.toml [ghostty]).
#
# config.ghostty ends with `config-file = ?local.ghostty`: an optional, untracked
# ~/.config/ghostty/local.ghostty for per-host settings (nothing creates it).
#
# If ~/.config/ghostty/config.ghostty already exists as a regular file, Home
# Manager refuses to overwrite it: move it aside (or `home-manager switch -b
# backup`) and diff it against config.ghostty here. Reload Ghostty after the
# first switch (cmd+shift+, or restart).
{
  config,
  lib,
  ...
}:

with lib;

let
  cfg = config.modules.programs.ghostty;
in
{
  options.modules.programs.ghostty = {
    checkoutDir = mkOption {
      type = types.str;
      default = "${config.home.homeDirectory}/workspace/home-nix";
      description = "Local home-nix checkout that holds modules/programs/ghostty/config.ghostty.";
    };
  };

  config = {
    xdg.configFile."ghostty/config.ghostty".source =
      config.lib.file.mkOutOfStoreSymlink "${cfg.checkoutDir}/modules/programs/ghostty/config.ghostty";
  };
}
