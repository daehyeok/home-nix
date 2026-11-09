# Main Home Manager configuration entry point
{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
{
  imports = [
    ./modules
    ./settings
    <catppuccin/modules/home-manager>
    ./modules/programs/zsh/emacs-editor.nix
  ];

  home = {
    username = "daehyeok";
    homeDirectory = "/Users/daehyeok";
    stateVersion = "26.05";
    packages = with pkgs; [
      devenv
      pre-commit
      fontconfig
      emacs-all-the-icons-fonts
      # D2Coding Nerd Font (Korean); installs as "D2KodingLigature Nerd Font".
      nerd-fonts.d2coding
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
    ];
  };

  catppuccin = {
    enable = true;
    autoEnable = false;
    flavor = "mocha";
    atuin.enable = true;
    bat.enable = true;
    starship.enable = true;
    delta.enable = true;
    nvim.enable = true;
  };

  # Enable flakes in ~/.config/nix/nix.conf (builtins.getFlake, used by the
  # Rex module, needs them).
  nix = {
    package = mkDefault pkgs.nix;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  xdg.enable = true;

  programs = {
    # Rex config only (~/.config/rex/init.lua); the Rex app provides the CLI,
    # so the module installs no package on macOS.
    rex.enable = true;
    starship.settings.format = " $directory$git_branch$git_commit$git_state$git_metrics$git_status$character";
    git.settings.user = {
      email = "daehyeok@gmail.com";
      name = "Daehyeok Mun";
    };

    zsh = {
      emacs-editor.enable = true;
      initContent = lib.mkBefore ''
        source /etc/static/bashrc  2> /dev/null
        source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
        source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"

        eval "$(/opt/homebrew/bin/brew shellenv)"
      '';
    };
  };
}
