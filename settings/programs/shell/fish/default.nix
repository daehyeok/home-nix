{ config, pkgs, ... }:

let dotDir = "${config.xdg.configHome}/zsh";
in {
  # home.packages=with pkgs;[babelfish];
  programs.fish = {
    functions = {
      term_editoor = ''
        if test -z "$INSIDE_EMACS"
           emacs -nw -q
        else
          #prevent runt emacs inside emacs
           vi
        end'';
      vterm_printf.body = ''
        if begin; [  -n "$TMUX" ]  ; and  string match -q -r "screen|tmux" "$TERM"; end
                      # tell tmux to pass the escape sequences through
                      printf "\ePtmux;\e\e]%s\007\e\\" "$argv"
                  else if string match -q -- "screen*" "$TERM"
                      # GNU screen (screen, screen-256color, screen-256color-bce)
                      printf "\eP\e]%s\007\e\\" "$argv"
                  else
                      printf "\e]%s\e\\" "$argv"
                  end'';
      vterm_prompt_end = "vterm_printf '51;A'(whoami)'@'(hostname)':'(pwd)";
    };
    interactiveShellInit = ''
      set fish_greeting ""
      if [ "$INSIDE_EMACS" = 'vterm' ]
          function clear
              vterm_printf "51;Evterm-clear-scrollback";
              tput clear;
          end
      end
    '';
  };
}
