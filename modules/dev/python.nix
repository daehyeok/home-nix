{
  config,
  options,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.dev.python;
in
{
  options.modules.dev.python = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable python development environment";
    };
  };

  config = mkIf cfg.enable {
    programs.uv = {
      enable = true;
      python = {
        versions = [ "3.15" ];
        default = "3.15";
        prune = true;
      };

      # Tools to install with `uv tool` during activation
      tool = {
        # Automatically remove tools no longer listed in tool.packages
        prune = true;
        packages = [
          "ruff"

          # Type checking & Language Servers (LSP)
          "basedpyright" # Full-featured fork of Pyright with strict defaults & LSP
          "ty" # Astral's ultra-fast Rust type checker and LSP

          # Testing & Debugging
          "pytest"
        ];
      };

      settings = {
        python-preference = "only-managed";
      };
    };
  };
}
