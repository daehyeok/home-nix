# Module for neovim configuration
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.programs.neovim;
in
{
  options.modules.programs.neovim = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable neovim configuration";
    };
  };

  config = mkIf cfg.enable {
    programs.neovim = {
      enable = mkDefault true;
      viAlias = true;
      vimAlias = true;
      plugins = [ pkgs.vimPlugins.nvim-treesitter.withAllGrammars ];
    };
  };
}
