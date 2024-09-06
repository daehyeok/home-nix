{ config, lib, pkgs, ... }:

{
  imports = [ ./git ./alacritty ./tmux ./shell ./fzf.nix ];

  programs = {
    jq.enable = true;
    bat.enable = true;
    zoxide.enable = true;
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
    };
    eza = {
      enable = true;
      extraOptions = [
        "--classify"
        "--group-directories-first"
        "--time-style=long-iso"
        "--group"
        "--color=auto"
      ];
      icons = true;
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
      nixfmt-rfc-style
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
