{ config, lib, pkgs, ... }:

{
  imports = [ ./git ./kitty ./tmux ./shell ./fzf.nix ];

  programs = {
    exa.enable = true;
    jq.enable = true;
    bat.enable = true;
    zoxide.enable = true;
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
    };
  };

  # Packages that should be installed to the user profile.
  home = {
    packages = with pkgs; [
      fd
      delta
      htop
      ripgrep
      ruplacer
      shellcheck
      tldr
      nixfmt
      gh
      choose
      wget
      bottom
    ];

    shellAliases = {
      diff = "delta";
      cat = "bat --plain";
    };
  };
}
