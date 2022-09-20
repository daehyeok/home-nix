{ config, pkgs, lib, ... }:
with lib; {
  imports = [ ./modules ./settings ];

  config = {
    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    home.username = "daehyeok";
    home.homeDirectory = "/Users/daehyeok";

    programs.git.userEmail = "daehyeok@gmail.com";
    programs.zinit.enable = true;
    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    home.stateVersion = "22.05";

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
    xdg.enable = true;

    modules.dev = {
      dart = { enable = true; };
      nix = { enable = true; };
    };
  };
}
