# OmniWM tiling window manager (macOS only). Import from mac_home.nix only:
# programs.omniwm exists in Home Manager master, and modules/programs/default.nix
# is shared with gLinux and the Pi, where setting a missing option fails evaluation.
#
# HM's programs.omniwm installs the app and its launchd agent. Its `settings`
# stays at {} so HM writes no read-only store copy; instead settings.toml is an
# out-of-store link into the home-nix checkout, so saves from OmniWM's GUI (and
# its schema upgrades) land in the checkout as a git diff. The GMac links the
# same file from the dotfiles nix/common submodule (home-gmac.toml [omniwm]).
{
  config,
  lib,
  ...
}:

with lib;

let
  cfg = config.modules.programs.omniwm;
in
{
  options.modules.programs.omniwm = {
    checkoutDir = mkOption {
      type = types.str;
      default = "${config.home.homeDirectory}/workspace/home-nix";
      description = "Local home-nix checkout that holds modules/programs/omniwm/settings.toml.";
    };
  };

  config = {
    programs.omniwm.enable = true;

    xdg.configFile."omniwm/settings.toml".source =
      config.lib.file.mkOutOfStoreSymlink "${cfg.checkoutDir}/modules/programs/omniwm/settings.toml";
  };
}
