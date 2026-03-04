{ pkgs ? import <nixpkgs> { } }:
let
  lib = pkgs.lib;
  # Test with defaults
  defaultsModule = {
    imports = [ ../modules/programs/zsh/emacs-editor.nix ];
    config.programs.zsh.emacs-editor.enable = true; # Enable to check zsh_integration default
  };
  defaultsCfg = (lib.evalModules { modules = [ defaultsModule ]; specialArgs = {}; }).config.programs.zsh.emacs-editor;

  # Test with options set
  setModule = {
    imports = [ ../modules/programs/zsh/emacs-editor.nix ];
    config.programs.zsh.emacs-editor = {
      enable = true;
      zsh_integration = false;
    };
  };
  setCfg = (lib.evalModules { modules = [ setModule ]; specialArgs = {}; }).config.programs.zsh.emacs-editor;
in
{
  test-options = pkgs.runCommand "test-emacs-editor-options" {
    ENABLE_DEFAULT = builtins.toString defaultsCfg.enable;
    ZSH_INTEGRATION_DEFAULT = builtins.toString defaultsCfg.zsh_integration;
    ENABLE_SET = builtins.toString setCfg.enable;
    ZSH_INTEGRATION_SET = builtins.toString setCfg.zsh_integration;
  } ''
    [[ "$ENABLE_DEFAULT" == "1" ]] || { echo "FAIL enable default: $ENABLE_DEFAULT"; exit 1; }
    [[ "$ZSH_INTEGRATION_DEFAULT" == "1" ]] || { echo "FAIL zsh_integration default: $ZSH_INTEGRATION_DEFAULT"; exit 1; }
    [[ "$ENABLE_SET" == "1" ]] || { echo "FAIL enable set: $ENABLE_SET"; exit 1; }
    [[ "$ZSH_INTEGRATION_SET" == "" ]] || { echo "FAIL zsh_integration set: $ZSH_INTEGRATION_SET"; exit 1; }
    echo "Option tests passed"
    touch $out
  '';
}
