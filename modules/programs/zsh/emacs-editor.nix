{ lib, config, ... }:
with lib;
{
  options.programs.zsh.emacs-editor = {
    enable = mkEnableOption "emacs-editor script for EDITOR";

    zsh_integration = mkOption {
      type = types.bool;
      default = true;
      description = "Set EDITOR environment variable in Zsh.";
    };
  };

  config = {
  };
}
