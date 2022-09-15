{ config, pkgs, ... }: {
  programs = {
    fzf = {
      enable = true;
      enableZshIntegration = false;
    };
    zinit = {
      snippets = [
        { url = "${config.programs.fzf.package}/share/fzf/completion.zsh"; }
        { url = "${config.programs.fzf.package}/share/fzf/key-bindings.zsh"; }
      ];
    };
  };
}
