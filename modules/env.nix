{ config, lib, pkgs, ... }:

with lib;

let cfg = config.env;
in {
  options = {
    env = {
      shellAliases = mkOption {
        default = { };
        description = lib.mdDoc ''
          Set of aliases for zsh shell, which overrides {option}`environment.shellAliases`.
          See {option}`environment.shellAliases` for an option format description.
        '';
        type = with types; attrsOf (nullOr (either str path));
      };
      paths = mkOption { default = [ ]; };
    };
  };

  config = mkMerge [

  ];

}
