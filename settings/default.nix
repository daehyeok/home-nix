# Main settings entry point for enabling modules and defining base environment
{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
{
  # Modules are now enabled by default in their respective files.
  # Overrides can be placed here if needed.
  modules = {
    # programs = { ... };
    # dev = { ... };
  };

  home = {
    packages = with pkgs; [
      choose
      gh
      nerd-fonts.hack
      nixfmt
      ruplacer
      sd
      shellcheck
      wget
    ];

    shellAliases = {
      diff = "delta";
    };

    sessionPath = [
      "$HOME/.config/emacs/bin"
      "$HOME/.bin"
    ];
  };
}
