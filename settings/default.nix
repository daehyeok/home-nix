{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
{
  programs = {
    jq.enable = true;
    bat = {
      enable = true;
      config = {
        theme = "Dracula";
      };
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
      icons = true;
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
      fastSyntaxHighlighting.enable = true;
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
  };

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
      tree = "eza --tree";
    };
    sessionPath = [
      "$HOME/.config/emacs/bin"
      "$HOME/.bin"
    ];
  };
}
