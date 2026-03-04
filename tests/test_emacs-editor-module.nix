{ pkgs ? import <nixpkgs> { } }:
let
  lib = pkgs.lib;
  # Test with defaults
  defaultsModule = { ... }:
  {
    imports = [ ../modules/programs/zsh/emacs-editor.nix ];
  };
  defaultsEval = (lib.evalModules { modules = [ defaultsModule ]; specialArgs = { inherit pkgs; }; });
  defaultsCfg = defaultsEval.config;

  # Test with options set (zsh_integration = true by default)
  setEnabledModule = { ... }:
  {
    imports = [ ../modules/programs/zsh/emacs-editor.nix ];
    config.programs.zsh.emacs-editor = {
      enable = true;
    };
  };
  setEnabledEval = (lib.evalModules { modules = [ setEnabledModule ]; specialArgs = { inherit pkgs; }; });
  setEnabledCfg = setEnabledEval.config;

  # Test with zsh_integration false
  setNoZshModule = { ... }:
  {
    imports = [ ../modules/programs/zsh/emacs-editor.nix ];
    config.programs.zsh.emacs-editor = {
      enable = true;
      zsh_integration = false;
    };
  };
  setNoZshEval = (lib.evalModules { modules = [ setNoZshModule ]; specialArgs = { inherit pkgs; }; });
  setNoZshCfg = setNoZshEval.config;

in
{
  test-options = pkgs.runCommand "test-emacs-editor-options" {
    ENABLE_DEFAULT = builtins.toString defaultsCfg.programs.zsh.emacs-editor.enable;
    ZSH_INTEGRATION_DEFAULT = builtins.toString defaultsCfg.programs.zsh.emacs-editor.zsh_integration;
    ENABLE_SET = builtins.toString setEnabledCfg.programs.zsh.emacs-editor.enable;
    ZSH_INTEGRATION_SET = builtins.toString setEnabledCfg.programs.zsh.emacs-editor.zsh_integration;
    ENABLE_NO_ZSH = builtins.toString setNoZshCfg.programs.zsh.emacs-editor.enable;
    ZSH_INTEGRATION_NO_ZSH = builtins.toString setNoZshCfg.programs.zsh.emacs-editor.zsh_integration;
  } ''
    [[ "$ENABLE_DEFAULT" == "" ]] || { echo "FAIL enable default: $ENABLE_DEFAULT"; exit 1; } # Should be false
    [[ "$ZSH_INTEGRATION_DEFAULT" == "1" ]] || { echo "FAIL zsh_integration default: $ZSH_INTEGRATION_DEFAULT"; exit 1; }
    [[ "$ENABLE_SET" == "1" ]] || { echo "FAIL enable set: $ENABLE_SET"; exit 1; }
    [[ "$ZSH_INTEGRATION_SET" == "1" ]] || { echo "FAIL zsh_integration set: $ZSH_INTEGRATION_SET"; exit 1; }
    [[ "$ENABLE_NO_ZSH" == "1" ]] || { echo "FAIL enable no zsh: $ENABLE_NO_ZSH"; exit 1; }
    [[ "$ZSH_INTEGRATION_NO_ZSH" == "" ]] || { echo "FAIL zsh_integration no zsh: $ZSH_INTEGRATION_NO_ZSH"; exit 1; }
    echo "Option tests passed"
    touch $out
  '';
}
