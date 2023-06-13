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
    ];
  };
}
