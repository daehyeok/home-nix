# Module for neovim configuration
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  config = mkIf config.programs.neovim.enable {
    programs.neovim = {
      viAlias = mkDefault true;
      vimAlias = mkDefault true;
      plugins = mkDefault [ pkgs.vimPlugins.nvim-treesitter.withAllGrammars ];
    };
  };
}
