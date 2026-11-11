{
  pkgs ? import <nixpkgs> { },
}:
let
  lib = pkgs.lib;
  # Minimal stand-ins for the Home Manager options the module sets, so it can be evaluated
  # without Home Manager.
  hmStubs = {
    options = {
      home.packages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [ ];
      };
      home.sessionVariables = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = { };
      };
      programs.zsh.sessionVariables = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = { };
      };
      programs.zsh.shellAliases = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = { };
      };
    };
  };
  # Test with defaults
  defaultsModule =
    { ... }:
    {
      imports = [ ../modules/programs/zsh/emacs-editor.nix ];
    };
  defaultsEval = (
    lib.evalModules {
      modules = [ hmStubs defaultsModule ];
      specialArgs = { inherit pkgs; };
    }
  );
  defaultsCfg = defaultsEval.config;

  # Test with options set (zsh_integration = true by default)
  setEnabledModule =
    { ... }:
    {
      imports = [ ../modules/programs/zsh/emacs-editor.nix ];
      config.programs.zsh.emacs-editor = {
        enable = true;
      };
    };
  setEnabledEval = (
    lib.evalModules {
      modules = [ hmStubs setEnabledModule ];
      specialArgs = { inherit pkgs; };
    }
  );
  setEnabledCfg = setEnabledEval.config;

  # Test with zsh_integration false
  setNoZshModule =
    { ... }:
    {
      imports = [ ../modules/programs/zsh/emacs-editor.nix ];
      config.programs.zsh.emacs-editor = {
        enable = true;
        zsh_integration = false;
      };
    };
  setNoZshEval = (
    lib.evalModules {
      modules = [ hmStubs setNoZshModule ];
      specialArgs = { inherit pkgs; };
    }
  );
  setNoZshCfg = setNoZshEval.config;

in
{
  test-options =
    pkgs.runCommand "test-emacs-editor-options"
      {
        ENABLE_DEFAULT = builtins.toString defaultsCfg.programs.zsh.emacs-editor.enable;
        ZSH_INTEGRATION_DEFAULT = builtins.toString defaultsCfg.programs.zsh.emacs-editor.zsh_integration;
        ENABLE_SET = builtins.toString setEnabledCfg.programs.zsh.emacs-editor.enable;
        ZSH_INTEGRATION_SET = builtins.toString setEnabledCfg.programs.zsh.emacs-editor.zsh_integration;
        ENABLE_NO_ZSH = builtins.toString setNoZshCfg.programs.zsh.emacs-editor.enable;
        ZSH_INTEGRATION_NO_ZSH = builtins.toString setNoZshCfg.programs.zsh.emacs-editor.zsh_integration;
        SCRIPT_BUILT = "${builtins.head setEnabledCfg.home.packages}/bin/emacs-editor";
        SCRIPT_SOURCE = ../modules/programs/emacs-editor;
        EMACS_ALIAS_SET = setEnabledCfg.programs.zsh.shellAliases.emacs or "";
        EMACS_ALIAS_NO_ZSH = setNoZshCfg.programs.zsh.shellAliases.emacs or "";
      }
      ''
        [[ "$ENABLE_DEFAULT" == "" ]] || { echo "FAIL enable default: $ENABLE_DEFAULT"; exit 1; } # Should be false
        [[ "$ZSH_INTEGRATION_DEFAULT" == "1" ]] || { echo "FAIL zsh_integration default: $ZSH_INTEGRATION_DEFAULT"; exit 1; }
        [[ "$ENABLE_SET" == "1" ]] || { echo "FAIL enable set: $ENABLE_SET"; exit 1; }
        [[ "$ZSH_INTEGRATION_SET" == "1" ]] || { echo "FAIL zsh_integration set: $ZSH_INTEGRATION_SET"; exit 1; }
        [[ "$ENABLE_NO_ZSH" == "1" ]] || { echo "FAIL enable no zsh: $ENABLE_NO_ZSH"; exit 1; }
        [[ "$ZSH_INTEGRATION_NO_ZSH" == "" ]] || { echo "FAIL zsh_integration no zsh: $ZSH_INTEGRATION_NO_ZSH"; exit 1; }
        [[ "$EMACS_ALIAS_SET" == "emacs-editor" ]] || { echo "FAIL emacs alias set: $EMACS_ALIAS_SET"; exit 1; }
        [[ "$EMACS_ALIAS_NO_ZSH" == "" ]] || { echo "FAIL emacs alias no zsh: $EMACS_ALIAS_NO_ZSH"; exit 1; }
        cmp -s "$SCRIPT_BUILT" "$SCRIPT_SOURCE" || { echo "FAIL installed script differs from modules/programs/emacs-editor"; exit 1; }
        echo "Option tests passed"
        touch $out
      '';
}
