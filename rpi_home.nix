# Main Home Manager configuration entry point
{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  vterm-build-deps = with pkgs; [
    cmake
    glibtool
  ];
in
{
  imports = [
    ./modules
    ./settings
    <catppuccin/modules/home-manager>
    ./modules/programs/zsh/emacs-editor.nix
  ];

  home = {
    username = "daehyeok";
    homeDirectory = "/home/daehyeok";
    stateVersion = "26.05";
    packages =
      with pkgs;
      [
        bitwarden-cli
        nodejs
        devenv
        pre-commit
        fontconfig
        emacs-all-the-icons-fonts
        gettext
        cargo-edit
        pkg-config
        openssl
        (python313.withPackages (
          ps: with ps; [
            pytest
            toml
            python-lsp-server
            pyls-isort
            flake8
            yapf
          ]
        ))
      ]
      ++ vterm-build-deps;
  };

  catppuccin = {
    flavor = "mocha";
    atuin.enable = true;
    bat.enable = true;
    starship.enable = true;
    delta.enable = true;
    nvim.enable = true;
    zellij.enable = true;
  };

  xdg.enable = true;

  programs = {
    starship.settings.format = " $directory$git_branch$git_commit$git_state$git_metrics$git_status$character";
    git.settings.user = {
      email = "daehyeok@gmail.com";
      name = "Daehyeok Mun";
    };
    emacs = {
      enable = true;
      # Use the 'No X' package flavor to drop all graphical requirements
      package = pkgs.emacs-nox;

      extraPackages = epkgs: [
        epkgs.vterm
      ];

      extraConfig = ''
        (use-package vterm
          :ensure nil
          :defer t)
      '';
    };
    zsh = {
      emacs-editor.enable = true;
      initContent = lib.mkBefore ''
                source /etc/static/bashrc  2> /dev/null
                [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ] && source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
                [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ] && source "$HOME/.nix-profile/etc/profile.d/nix.sh"
                [ -e "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ] && source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"

                [[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"

                [[ -f ~/.local_env ]] && source ~/.local_env
        	path+=($HOME/.local/bin $HOME/.npm-global/bin)
      '';
    };
  };
  services.emacs = {
    enable = true;
    package = config.programs.emacs.finalPackage; # Ensures daemon uses emacs-nox wrapper
  };
}
