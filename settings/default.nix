# Main settings entry point for enabling modules and defining base environment
{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
{
  modules = {
    programs = {
      zsh.enable = true;
      atuin.enable = true;
      delta.enable = true;
      git.enable = true;
      jq.enable = true;
      bat.enable = true;
      zoxide.enable = true;
      neovim.enable = true;
      eza.enable = true;
      fzf.enable = true;
      tmux.enable = true;
      zellij.enable = true;
      tealdeer.enable = true;
      ripgrep.enable = true;
      fd.enable = true;
      htop.enable = true;
      bottom.enable = true;
      direnv.enable = true;
    };
    dev = {
      nix.enable = true;
    };
  };

  # Legacy direct enables (for modules that don't yet use the modules.programs pattern)
  programs = {
    starship.enable = true;
  };

  home = {
    packages = with pkgs; [
      choose
      gh
      nerd-fonts.hack
      nixfmt
      ruplacer
      sd
      shellcheck
      wget
    ];

    shellAliases = {
      diff = "delta";
      cat = "bat --plain";
      tree = "eza --tree";
    };

    sessionPath = [
      "$HOME/.config/emacs/bin"
      "$HOME/.bin"
    ];
  };
}
