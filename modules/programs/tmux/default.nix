# Module for tmux configuration
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  options.programs.tmux.extraConfigSet = mkOption {
    type = types.listOf types.lines;
    default = [];
    description = "A set of extra configuration lines to add to tmux.conf.";
  };

  config = mkIf config.programs.tmux.enable {
    programs.tmux = {
      mouse = mkDefault true;
      extraConfig = concatStringsSep "
" ([
        ''
          bind  c new-window  -c "#{pane_current_path}"
          set-option -g default-shell $SHELL
          set -s set-clipboard on
          set -g allow-passthrough
          set -as terminal-features ",*:hyperlinks"
        ''
      ] ++ config.programs.tmux.extraConfigSet);
      plugins = with pkgs; mkDefault [
        tmuxPlugins.copycat
        tmuxPlugins.open
        tmuxPlugins.yank
        {
          plugin = pkgs.tmuxPlugins.catppuccin;
          extraConfig = ''
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
          '';
        }
      ];
    };
  };
}
