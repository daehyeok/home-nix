# Module for tmux configuration
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  options.programs.tmux.extraConfigSet = lib.mkOption {
    type = lib.types.lines;
    default = "";
    description = "A set of extra configuration lines to add to tmux.conf.";
  };

  config = mkIf config.programs.tmux.enable {
    programs.tmux = {
      mouse = mkDefault true;
      terminal = mkDefault "xterm-256color";
      extraConfig = lib.mkMerge [
        config.programs.tmux.extraConfigSet

        # This will be forced to the absolute bottom
        (lib.mkAfter ''
          # --- TPM Management ---
          # Set the path variable
          plugin_path="~/.config/tmux/plugins"
          tpm_path="$plugin_path/tpm"

          if-shell "test ! -d $tpm_path" {
            run-shell "mkdir -p $plugin_path"
            run-shell "git clone https://github.com/tmux-plugins/tpm $tpm_path"
            run-shell "$tpm_path/bin/install_plugins"
          }

          run "$tpm_path/tpm"
        '')
      ];
      extraConfigSet = ''
        bind  c new-window  -c "#{pane_current_path}"
        set-option -g default-shell $SHELL
        set -s set-clipboard on
        set -g allow-passthrough
        set -as terminal-features ",*:hyperlinks"

        # catppuccin theme
        set -g @plugin 'catppuccin/tmux#v2.1.3'
        set -g @catppuccin_flavour 'mocha'
        set -g @catppuccin_window_status_style "rounded"
        set -g @catppuccin_window_current_text "#(bash ${./window_text.sh} '#T' '#W' '#{pane_current_path}')"
        set -g @catppuccin_window_default_text "#(bash ${./window_text.sh} '#T' '#W' '#{pane_current_path}')"
        set -g @catppuccin_window_text "#(bash ${./window_text.sh} '#T' '#W' '#{pane_current_path}')"

        set -g status-interval 1
        set -g status-right-length 100
        set -g status-left-length 100
        set -g status-left ""
        set -g status-right "#{E:@catppuccin_status_date_time}"

        set -g @plugin 'tmux-plugins/tmux-copycat'
        set -g @plugin 'tmux-plugins/tmux-yank'
        set -g @plugin 'tmux-plugins/tmux-open'
      '';
    };
  };
}
