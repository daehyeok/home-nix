# Atuin shell history configuration module.
#
# By default, hosts enable Home Manager's `programs.atuin` (via settings/default.nix)
# to install `pkgs.atuin` from nixpkgs. On hosts where nixpkgs builds `atuin` from
# source and compilation is slow (e.g. Raspberry Pi), set:
#   programs.atuin.useSetupScript = true;
# to disable the Nix package, install the prebuilt binary via https://setup.atuin.sh
# when missing, and generate Zsh's `_atuin` completion into XDG dataHome.
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.atuin;
  zshCompletionDir = "${config.xdg.dataHome}/zsh/completions";
  zshCacheDir = "${config.xdg.cacheHome}/zsh";
  atuinSearchPath = "$HOME/.atuin/bin:$HOME/.local/bin:$HOME/.nix-profile/bin:/usr/bin:/bin";
in
{
  options.programs.atuin = {
    useSetupScript = mkEnableOption "installing Atuin via https://setup.atuin.sh instead of pkgs.atuin";
  };

  config = mkIf cfg.useSetupScript {
    programs.atuin.enable = mkForce false;

    home.sessionPath = [
      "$HOME/.atuin/bin"
    ];

    home.activation.installAtuin =
      hm.dag.entryAfter
        [
          "installPackages"
          "linkGeneration"
          "ensureUserZshrc"
        ]
        ''
          if ! PATH="${atuinSearchPath}:$PATH" command -v atuin >/dev/null 2>&1; then
            if [ -n "''${DRY_RUN:-}" ]; then
              verboseEcho "Would install atuin via https://setup.atuin.sh"
            else
              (
                export PATH="${
                  makeBinPath (
                    with pkgs;
                    [
                      curl
                      gawk
                      gnutar
                      gzip
                      xz
                    ]
                  )
                }:/usr/bin:/bin:$PATH"
                unset ZDOTDIR ATUIN_SESSION ATUIN_HISTORY_ID ATUIN_SHLVL
                curl --proto '=https' --tlsv1.2 --retry 3 -LsSf https://setup.atuin.sh | sh -s -- --non-interactive
              )
            fi
          fi

          ${optionalString config.programs.zsh.enable ''
            if atuinBin="$(PATH="${atuinSearchPath}:$PATH" command -v atuin 2>/dev/null)"; then
              compDir="${zshCompletionDir}"
              compFile="$compDir/_atuin"
              if [ -n "''${DRY_RUN:-}" ]; then
                verboseEcho "Would ensure zsh completion at $compFile"
              else
                mkdir -p "$compDir"
                chmod 0755 "${config.xdg.dataHome}/zsh" "$compDir"
                tmpComp="$(mktemp "$compDir/.atuin.XXXXXX")"
                if "$atuinBin" gen-completions --shell zsh > "$tmpComp"; then
                  if [ ! -f "$compFile" ] || ! cmp -s "$tmpComp" "$compFile"; then
                    chmod 0644 "$tmpComp"
                    mv "$tmpComp" "$compFile"
                    rm -f "${zshCacheDir}"/.zcompdump*
                  else
                    rm -f "$tmpComp"
                  fi
                else
                  rm -f "$tmpComp"
                fi
              fi
            fi
          ''}
        '';
  };
}
