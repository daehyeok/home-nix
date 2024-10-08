{
  config,
  pkgs,
  lib,
  ...
}:
let
  vterm-build-deps = with pkgs; [
    cmake
    glibtool
  ];
  home = builtins.getEnv "HOME";
in
with lib;
{
  imports = [
    ./modules
    ./settings
  ];

  config = {
    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    home = {
      username = "daehyeok";
      homeDirectory = "/Users/daehyeok";
      stateVersion = "23.05";
      packages =
        with pkgs;
        [
          fontconfig
          (nerdfonts.override { fonts = [ "Hack" ]; })
          emacs-all-the-icons-fonts
          gettext
          cargo-edit
          pkg-config
          openssl
        ]
        ++ vterm-build-deps;
    };

    programs = {
      # Let Home Manager install and manage itself.
      home-manager.enable = true;
      zsh = {
        enable = true;
        initExtraFirst = ''
          source /etc/static/bashrc  2> /dev/null
          source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
          source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"

          eval "$(/opt/homebrew/bin/brew shellenv)"
        '';
      };
      git.userEmail = "daehyeok@gmail.com";
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
    };

    xdg.enable = true;

    modules.dev = {
      nix = {
        enable = true;
      };
    };
  };
}
