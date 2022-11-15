{ config, pkgs, lib, ... }:
with lib; {
  home = {
    packages = with pkgs; [ d2coding ];
    sessionVariables = {
      TERMINFO_DIRS =
        "$HOME/.nix-profile/share/terminfo:/etc/terminfo:/lib/terminfo:/usr/share/terminfo";
    };
    file = {
      "kitty.conf" = {
        source = pkgs.substituteAll {
          src = ./kitty.conf;
          fontSize = if pkgs.stdenv.isDarwin then 13 else 20;
        };
        target = ".config/kitty/kitty.conf";
      };
    };
  };
}
