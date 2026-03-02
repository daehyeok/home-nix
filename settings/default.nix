# Main settings entry point for enabling modules and defining base environment
{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
{
  # Core program enablement. These trigger our opinionated modules in modules/programs/
  programs = {
    atuin.enable = true;
    bat.enable = true;
    bottom.enable = true;
    delta.enable = true;
    direnv.enable = true;
    fd.enable = true;
    fzf.enable = true;
    git.enable = true;
    htop.enable = true;
    jq.enable = true;
    lsd.enable = true;
    neovim.enable = true;
    ripgrep.enable = true;
    starship.enable = true;
    tealdeer.enable = true;
    tmux.enable = true;
    zellij.enable = true;
    zoxide.enable = true;
    zsh.enable = true;
  };

  modules = {
    dev = {
      nix.enable = true;
    };
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
    };

    sessionPath = [
      "$HOME/.config/emacs/bin"
      "$HOME/.bin"
    ];
  };
}
