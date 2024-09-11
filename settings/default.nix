{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
{
  imports = [ ./programs ];

  home = {
    sessionPath = [
      "$HOME/.config/emacs/bin"
      "$HOME/.bin"
    ];
  };
}
