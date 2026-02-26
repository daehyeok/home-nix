# Module for tmux configuration
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.programs.tmux;
in
{
  options.modules.programs.tmux = {
    enable = mkEnableOption "tmux configuration";
  };

  config = mkIf cfg.enable {
    programs.tmux = {
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
        {
          plugin = pkgs.tmuxPlugins.catppuccin;
          extraConfig = ''
            set -g @catppuccin_flavour 'mocha'

            set -g @catppuccin_window_status_style "rounded"

            set -g @catppuccin_window_current_text "#(bash window_text.sh '#T' '#W')"
            set -g @catppuccin_window_default_text "#(bash window_text.sh '#T' '#W')"
            set -g @catppuccin_window_text "#(bash window_text.sh '#T' '#W')"

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
