{ config, pkgs, osConfig, lib, ... }:
let
  vterm-build-deps = with pkgs; [ cmake ];
  home = builtins.getEnv "HOME";
in {
  imports = [ <home-manager/nix-darwin> ];

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  # environment.systemPackages = [ pkgs.emacs ];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/zshrc that loads the nix-darwin environment.
  # programs.zsh.enable = true;
  # default shell on catalina
  # programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  users.users.daehyeok = { home = "/Users/daehyeok"; };

  homebrew = {
    enable = true;
    brews = [ "libvterm" "libtool" ];
  };

  home-manager.useGlobalPkgs = true;
  home-manager.users.daehyeok = {

    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    home = {
      username = "daehyeok";
      homeDirectory = "/Users/daehyeok";
      stateVersion = "23.05";
      packages = with pkgs;
        [
          fontconfig
          (nerdfonts.override { fonts = [ "Hack" ]; })
          gettext
          cargo-edit
          pkg-config
          openssl
          eask
        ] ++ vterm-build-deps;

      sessionPath = [ "/Users/daehyeok/.local/share/cargo/bin" ];
      sessionVariables = {        };
    };

    imports = [ ./modules ./settings ];

    programs = {
      # # Let Home Manager install and manage itself.
      # home-manager.enable = true;
      zsh = {
        enable = true;
        initExtraFirst = ''
          source /etc/static/bashrc  2> /dev/null
          source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
          source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
          export NIX_PATH=$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels''${NIX_PATH:+:$NIX_PATH}
          eval "$(/opt/homebrew/bin/brew shellenv)"'';
      };
      starship.enable = true;
      git.userEmail = "daehyeok@gmail.com";
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
      emacs = {
        enable = true;
        package = pkgs.emacs;
        extraPackages = (epkgs: [ epkgs.vterm epkgs.eask ]);
      };
    };

    xdg.enable = true;
    modules.dev = {
      nix = { enable = true; };
    };
  };
}
