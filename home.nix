{ config, pkgs, lib, ... }:
with lib; {
  imports = [ ./modules ./settings ];

  config = {

    nixpkgs.overlays = [
      (import (builtins.fetchTarball {
        url =
          "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
      }))
    ];

    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    home = {
      username = "daehyeok";
      homeDirectory = "/Users/daehyeok";
      stateVersion = "22.05";
      packages = with pkgs; [
        kitty
        (nerdfonts.override { fonts = [ "Hack" ]; })
      ];
    };

    programs = {
      # Let Home Manager install and manage itself.
      home-manager.enable = true;
      starship.enable = true;
      git.userEmail = "daehyeok@gmail.com";
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
      zinit.enable = true;
      zsh.initExtra = "typeset -g LC_ALL=en_US.UTF-8";
      emacs = {
        enable = true;
        package = pkgs.emacsNativeComp;
        extraPackages = (epkgs: [ epkgs.vterm ]);
      };
    };

    xdg.enable = true;

    modules.dev = {
      dart = { enable = true; };
      nix = { enable = true; };
    };
  };
}
