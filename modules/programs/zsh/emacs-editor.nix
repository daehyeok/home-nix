{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.programs.zsh.emacs-editor;
  # Single source: ../emacs-editor (also exercised by tests/test_emacs-editor.sh and
  # linked as-is on the GMac by home-gmac).
  emacs-editor-script = pkgs.writeScriptBin "emacs-editor" (builtins.readFile ../emacs-editor);
in
{
  options.programs.zsh.emacs-editor = {
    enable = mkEnableOption "emacs-editor script for EDITOR";

    zsh_integration = mkOption {
      type = types.bool;
      default = true;
      description = "Set EDITOR to emacs-editor and alias emacs to it in Zsh.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ emacs-editor-script ];

    home.sessionVariables = lib.mkIf cfg.zsh_integration {
      EDITOR = "emacs-editor";
    };

    programs.zsh = lib.mkIf cfg.zsh_integration {
      sessionVariables = {
        EDITOR = "emacs-editor";
      };
      # `emacs` goes through the script too; option args (emacs --version, -Q, ...) reach the
      # real emacs because the script hands them over unchanged.
      shellAliases = {
        emacs = "emacs-editor";
      };
    };
  };
}
