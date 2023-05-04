{ config, pkgs, ... }: {
  home.packages = with pkgs; [ tmux ];

  programs.tmux = {
    enable = true;
    terminal = "xterm-kitty";
    extraConfig = ''
      bind  c new-window  -c "#{pane_current_path}"
      set-option -g update-environment "DISPLAY WAYLAND_DISPLAY SWAYSOCK SSH_AUTH_SOCK"
      set-option -g default-shell $SHELL
    '';
    plugins = with pkgs; [
      tmuxPlugins.copycat
      tmuxPlugins.open
      tmuxPlugins.yank
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      }
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '60' # minutes
        '';
      }
    ];
  };
}
