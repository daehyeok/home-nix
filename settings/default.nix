{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
{
  programs = {
    atuin = {
      enable = true;
    };
    git = {
      enable = true;
      delta = {
        enable = true;
        options = {
          navigate = true;
          side-by-side = true;
        };
      };
      extraConfig = {
        merge.conflictstyle = "zdiff3";
      };
    };
    jq.enable = true;
    bat = {
      enable = true;
    };
    zoxide.enable = true;
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
    };
    eza = {
      enable = true;
      enableZshIntegration = true;
      extraOptions = [
        "--classify"
        "--group-directories-first"
        "--time-style=long-iso"
        "--group"
        "--color=auto"
      ];
      icons = "auto";
    };
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
    tmux = {
      enable = true;
      extraConfig = ''
        bind  c new-window  -c "#{pane_current_path}"
        set-option -g update-environment "DISPLAY WAYLAND_DISPLAY SWAYSOCK SSH_AUTH_SOCK"
        set-option -g default-shell $SHELL
        set -s set-clipboard on
        set -g allow-passthrough
      '';
      plugins = with pkgs; [
        tmuxPlugins.copycat
        tmuxPlugins.open
        tmuxPlugins.yank
      ];
    };
    starship.enable = true;
    zsh = {
      enableCompletion = true;
      autosuggestion = {
        enable = true;
        strategy = [
          "history"
          "completion"
        ];
      };
      fastSyntaxHighlighting.enable = lib.mkDefault true;
      autoPair.enable = true;
      completionsPlugin.enable = true;
      vterm.enable = true;

      dotDir = ".config/zsh";

      history = {
        ignoreDups = true;
        ignoreSpace = true;
        extended = true;
        expireDuplicatesFirst = true;
        share = true;
        size = 1000;
        save = 1000;
        path = "${config.xdg.dataHome}/zsh/zsh_history";
      };
      #TODO   { url = "OMZP::safe-paste"; }
      initExtra = ''
        [[ -f ~/.zshrc.local ]] && source ~/.zshrc.local                
      '';
      sessionVariables = {
        ZSH_CACHE_DIR = "${config.xdg.cacheHome}/zsh";
        "WORDCHARS" = "''";
      };
    };
    zellij.enable = true;
  };

  home = {
    packages = with pkgs; [
      fd
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
      sd
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
