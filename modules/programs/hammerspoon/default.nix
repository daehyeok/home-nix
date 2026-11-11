# Hammerspoon config (macOS only), link-only. Import from mac_home.nix only:
# modules/programs/default.nix is shared with gLinux and the Pi.
#
# Hammerspoon may be installed outside Nix (official zip or Homebrew cask), so
# this module installs nothing. It only links ~/.hammerspoon/init.lua to the
# home-nix checkout (out-of-store, so edits land in the checkout as a git
# diff). The GMac links the same file from the dotfiles nix/common submodule
# (home-gmac.toml [hammerspoon]).
#
# If ~/.hammerspoon/init.lua already exists as a regular file, Home Manager
# refuses to overwrite it: move it aside (or `home-manager switch -b backup`)
# and diff it against init.lua here. Reload Hammerspoon after the first switch
# (menu bar > Reload Config); it doesn't watch the file.
{
  config,
  lib,
  ...
}:

with lib;

let
  cfg = config.modules.programs.hammerspoon;
in
{
  options.modules.programs.hammerspoon = {
    checkoutDir = mkOption {
      type = types.str;
      default = "${config.home.homeDirectory}/workspace/home-nix";
      description = "Local home-nix checkout that holds modules/programs/hammerspoon/init.lua.";
    };
  };

  config = {
    home.file.".hammerspoon/init.lua".source =
      config.lib.file.mkOutOfStoreSymlink "${cfg.checkoutDir}/modules/programs/hammerspoon/init.lua";
  };
}
