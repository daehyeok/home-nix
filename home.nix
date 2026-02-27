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
  ];

  home = {
    username = "daehyeok";
    homeDirectory = "/Users/daehyeok";
    stateVersion = "26.05";
    packages =
      with pkgs;
      [
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

  programs.zsh = {
    initContent = lib.mkBefore ''
      source /etc/static/bashrc  2> /dev/null
      source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"

      eval "$(/opt/homebrew/bin/brew shellenv)"

      [[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
    '';
  };
}
