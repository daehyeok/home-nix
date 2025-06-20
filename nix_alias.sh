#!/usr/bin/env zsh

apps_dir="/Applications/Nix"

function log {
    echo $1
}

# Helpers
function new_alias {
  local -r app="${1}"
  local -r dest_dir="${2}"

  /usr/bin/osascript -e '
    on run argv
      tell application "Finder" to make alias to POSIX file (item 1 of argv) at POSIX file (item 2 of argv)
    end run
  ' "${app}" "${dest_dir}"
}

function refresh_alias {
    rm -rf ${apps_dir}
    mkdir -p ${apps_dir}

    for app_link in ${HOME}/.nix-profile/Applications/*.app; do
        local app=${app_link}
        local app_dest="${apps_dir}/${app:t:r}"

        log "Tyring to link \"${app}\" to \"${app_dest}\""

        new_alias "${app}" "${apps_dir}"
    done
}

refresh_alias
