{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
{
  home = {
    packages = with pkgs; [ d2coding ];
    file = {
      "alacritty.toml" = {
        source = pkgs.substituteAll {
          src = ./alacritty.toml;
          fontSize = if pkgs.stdenv.isDarwin then 13 else 20;
        };
        target = ".config/alacritty/alacritty.toml";
      };
    };
  };
}
