# Base system and user configuration module
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
  config = {
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
  };
}
