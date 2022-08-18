{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    zsh-autopair
    zsh-autosuggestions
    zsh-powerlevel10k
    zsh-fast-syntax-highlighting
  ];
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autocd = true;
    enableAutosuggestions = true;
    history = {
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
      size = 3000;
    };
    plugins = with pkgs; [
      {
        name = "ls";
        src = pkgs.fetchFromGitHub {
          owner = "zpm-zsh";
          repo = "ls";
          rev = "4c93ff4f13116a2260eb5f4bd77dfc62092f2d35";
          sha256 = "/Z6e5YuIwwPABuNOTXVzVnoSP2hzEP32d/M0kJypwAk=";
        };
      }
      {
        name = "powerlevel10k";
        file = "powerlevel10k.zsh-theme";
        src = "${zsh-powerlevel10k}/share/zsh-powerlevel10k";
      }
      {
        name = "zsh-autopair";
        file = "zsh-autopair.zsh";
        src = "${zsh-autopair}/share/zsh/zsh-autopair";
      }
      {
        name = "fast-syntax-highlighting";
        file = "fast-syntax-highlighting.plugin.zsh";
        src = "${zsh-fast-syntax-highlighting}/share/zsh/site-functions";
      }
      {
        name = "wd";
        src = pkgs.fetchFromGitHub {
          owner = "mfaerevaag";
          repo = "wd";
          rev = "eaf39c0b8a0b3b99fa5f0904612f2230c5f20634";
          sha256 = "UWA3AMNZW5WYRAy7ebi6CLTjxnu/tuddY2sUXMbsFkY=";
        };
      }
      {
        name = "zsh-interactive-cd";
        src = pkgs.fetchFromGitHub {
          owner = "changyuheng";
          repo = "zsh-interactive-cd";
          rev = "7bbe02e9444cf335beab1cc27f957d799ae89dab";
          sha256 = "jqWkCT9IyL+inOyxCGQlFezJ1boiB46frjKpBljQJyc=";
        };
      }
    ];
    initExtraBeforeCompInit = builtins.readFile ./zshrc;
    initExtra = ''
      [[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
                    [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    '';
    shellAliases = {
      diff = "delta";
      cat = "bat --plain";
      tree = "exa --tree";
    };
  };

  home.file = {
    ".p10k.zsh" = {
      source = ./p10k.zsh;
      target = ".p10k.zsh";
    };
  };
}
