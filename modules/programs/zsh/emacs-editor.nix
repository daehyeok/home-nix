{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.programs.zsh.emacs-editor;
  emacs-editor-script = pkgs.writeScriptBin "emacs-editor" ''
    #!/usr/bin/env bash

    if ${pkgs.emacs}/bin/emacsclient -e t > /dev/null 2>&1; then
      # Server is running
      if [[ -n "$INSIDE_EMACS" ]]; then
        # Inside Emacs
        ${pkgs.emacs}/bin/emacsclient "$@"
      else
        # Not inside Emacs
        ${pkgs.emacs}/bin/emacsclient -nw "$@"
      fi
    else
      # Server is not running
      ${pkgs.emacs}/bin/emacs -q "$@"
    fi
  '';
in
{
  options.programs.zsh.emacs-editor = {
    enable = mkEnableOption "emacs-editor script for EDITOR";

    zsh_integration = mkOption {
      type = types.bool;
      default = true;
      description = "Set EDITOR environment variable in Zsh.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ emacs-editor-script ];

    home.sessionVariables = lib.mkIf cfg.zsh_integration {
      EDITOR = "emacs-editor";
    };
  };
}
