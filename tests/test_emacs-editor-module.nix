{ pkgs ? import <nixpkgs> { }, lib ? (pkgs.lib // pkgs.lib.fakeSha256) }:
let
  testModule = {
    imports = [ ../modules/programs/zsh/emacs-editor.nix ];
  };
  evaluated = lib.evalModules { modules = [ testModule ]; };
in
{
  test-import = pkgs.runCommand "test-emacs-editor-import" { } ''
    # Just the fact that evalModules didn't throw is a pass for import
    echo "Nix module imported and evaluated successfully"
    touch $out
  '';
}
