#!/bin/bash
# Custom script to format tmux window titles with icons and compressed paths.
# Usage: window_text.sh <pane_title> <window_name> <pane_current_path>

# Trim spaces just in case tmux pads pane_title
pane_title=$(echo "$1" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
window_name=$(echo "$2" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
pane_current_path=$(echo "$3" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

host_name=$(hostname)
host_short=$(hostname -s)

compress_path() {
    local path="$1"

    # Handle Google Cloud (CitC) paths
    # Format: */google/src/cloud/{user}/{workspace}/{dir_type}/...
    if [[ "$path" == *"/google/src/cloud/"* ]]; then
        local rest_citc="${path#*/google/src/cloud/}"
        local workspace_rest="${rest_citc#*/}"
        local workspace="${workspace_rest%%/*}"
        local dir_type_rest="${workspace_rest#*/}"
        local dir_type="${dir_type_rest%%/*}"
        local rest="${dir_type_rest#*/}"

        if [[ "$workspace_rest" == "$workspace" ]]; then
            dir_type=""
            rest=""
        elif [[ "$dir_type_rest" == "$dir_type" ]]; then
            rest=""
        fi

        # Refined logic for special directory types
        local effective_dir_type="$dir_type"
        if [[ "$dir_type" == "google3" ]]; then
            local next_dir="${rest%%/*}"
            if [[ "$next_dir" == blaze-* || "$next_dir" == "java" || "$next_dir" == "javatests" ]]; then
                effective_dir_type="$next_dir"
                local next_rest="${rest#*/}"
                if [[ "$rest" == "$next_dir" ]]; then
                    rest=""
                else
                    rest="$next_rest"
                fi
            fi
        fi

        if [[ -z "$effective_dir_type" ]]; then
             # Path is too short, fall back to standard compression
             :
        elif [[ "$path" == *"/google/src/cloud/"*/*/* ]]; then
             if [[ -z "$rest" ]]; then
                 echo "($workspace:$effective_dir_type)"
                 return
             else
                 # Compress the rest of the path with // separator
                 local IFS='/'
                 read -ra ADDR <<< "$rest"
                 local len=${#ADDR[@]}
                 if [[ $len -gt 1 ]]; then
                     echo "($workspace:$effective_dir_type)//.../${ADDR[$((len-1))]}"
                 else
                     echo "($workspace:$effective_dir_type)//$rest"
                 fi
                 return
             fi
        fi
    fi

    # Replace $HOME with ~
    if [[ "$path" == "$HOME" ]]; then
        path="~"
    elif [[ "$path" == "$HOME/"* ]]; then
        path="~${path#$HOME}"
    fi

    # Shorten intermediate directories (e.g., ~/projects/my-app -> ~/p/my-app)
    local IFS='/'
    read -ra ADDR <<< "$path"
    local len=${#ADDR[@]}

    if [[ "${ADDR[0]}" == "~" ]]; then
        if [[ $len -gt 2 ]]; then
            echo "~/.../${ADDR[$((len-1))]}"
            return
        fi
    elif [[ -z "${ADDR[0]}" && $len -gt 1 ]]; then
        # Absolute path starting with /
        if [[ $len -gt 2 ]]; then
            echo "/.../${ADDR[$((len-1))]}"
            return
        fi
    elif [[ $len -gt 1 ]]; then
        # Relative path
        echo ".../${ADDR[$((len-1))]}"
        return
    fi

    echo "$path"
}

# Use window_name if pane_title is empty or the hostname.
# Otherwise, we use the specific pane_title.
if [[ -z "$pane_title" || "$pane_title" == "$host_name" || "$pane_title" == "$host_short" ]]; then
    base_name="$window_name"
else
    base_name="$pane_title"
fi

get_icon() {
    local lower_name=$(echo "$1" | tr '[:upper:]' '[:lower:]')
    case "$lower_name" in
        alacritty|gnome-terminal|iterm2) echo "" ;;
        ansible) echo "" ;;
        ant) echo "" ;;
        apache2|httpd|nginx) echo "" ;;
        apt|dpkg|nala) echo "" ;;
        atom) echo "" ;;
        aws) echo "" ;;
        babel) echo "" ;;
        bash|fish|just|nu|tcsh|zsh) echo "" ;;
        bat|.bat-wrapped) echo "󰭟" ;;
        bazel|blaze) echo "" ;;
        beam|beam.smp) echo "" ;;
        bitbucket) echo "" ;;
        brew) echo "" ;;
        btm|btop|glances|htop|mactop|top) echo "" ;;
        caffeinate) echo "" ;;
        cargo|rustc|rustup) echo "" ;;
        cfdisk|fdisk|parted) echo "" ;;
        clang|gcc) echo "" ;;
        cli|gcc) echo "" ;;
        clion|idea|pycharm) echo "" ;;
        cmake|julia|make) echo "" ;;
        code|code-insiders) echo "" ;;
        composer) echo "" ;;
        console) echo "󰞷" ;;
        crontab) echo "" ;;
        csharp) echo "" ;;
        curl|wget) echo "" ;;
        dart|flutter) echo "" ;;
        deno) echo "" ;;
        dnf|yum) echo "" ;;
        docker|lazydocker) echo "" ;;
        doctl) echo "" ;;
        dotnet) echo "" ;;
        eclipse) echo "" ;;
        elixir) echo "" ;;
        emacs) echo "" ;;
        firebase) echo "" ;;
        gcloud) echo "" ;;
        gdb|lldb|valgrind) echo "" ;;
        gh|gitlab|wordpress) echo "" ;;
        ghc|stack) echo "" ;;
        ghostty) echo "" ;;
        git|gitui|lazygit|tig) echo "" ;;
        go) echo "" ;;
        gpg) echo "" ;;
        gping|ping) echo "" ;;
        gradle) echo "" ;;
        grunt) echo "" ;;
        gulp) echo "" ;;
        helm|k9s|kubectl|kubie|minikube) echo "󱃾" ;;
        heroku) echo "" ;;
        hg|lazyjj|svn|jj) echo "" ;;
        hx) echo "󰔤" ;;
        java) echo "" ;;
        jekyll) echo "" ;;
        jenkins) echo "" ;;
        jest) echo "" ;;
        laravel) echo "" ;;
        lf|lfcd|ranger) echo "" ;;
        lvim|vi|vim) echo "" ;;
        maven) echo "" ;;
        mocha) echo "" ;;
        mongo) echo "" ;;
        mysql) echo "" ;;
        nano) echo "" ;;
        netbeans) echo "" ;;
        ng) echo "" ;;
        node|yarn) echo "" ;;
        npm) echo "" ;;
        nvim) echo "" ;;
        openssl) echo "" ;;
        pacman|paru|yay) echo "" ;;
        perl) echo "" ;;
        php) echo "" ;;
        pip*|python*) echo "" ;;
        powershell) echo "" ;;
        psql) echo "" ;;
        puppet) echo "" ;;
        r) echo "ﳒ" ;;
        react) echo "" ;;
        redis) echo "" ;;
        rsync) echo "" ;;
        ruby) echo "" ;;
        scala) echo "" ;;
        scp|ssh) echo "󰣀" ;;
        screen|tmux) echo "" ;;
        sqlite) echo "" ;;
        sublime_text) echo "" ;;
        sudo) echo "" ;;
        swift) echo "" ;;
        systemctl) echo "" ;;
        terraform) echo "ﲽ" ;;
        tickrs) echo "" ;;
        topgrade) echo "󰚰" ;;
        travis) echo "" ;;
        tsc) echo "" ;;
        unicorn) echo "󱗃" ;;
        unzip|zip) echo "" ;;
        vagrant) echo "" ;;
        virtualbox) echo "" ;;
        visualstudio) echo "" ;;
        vue) echo "﵂" ;;
        webpack) echo "" ;;
        weechat) echo "󰭹" ;;
        yazi) echo "" ;;
        zig) echo "↯" ;;
        *) echo "" ;; # default fallback icon
    esac
}

icon=$(get_icon "$base_name")
output_text="$base_name"

if [[ "$base_name" =~ ^(bash|zsh|fish|nu|sh|fish-wrapped|.zsh-wrapped|.bash-wrapped)$ && -n "$pane_current_path" ]]; then
    output_text=$(compress_path "$pane_current_path")
elif [[ "$base_name" == "cli" ]]; then
    if [[ -n "$pane_current_path" && "$pane_current_path" != "/" ]]; then
        cur_dir=$(basename "$pane_current_path")
        output_text="jetski-cli ($cur_dir)"
    else
        output_text="jetski-cli"
    fi
fi

if [ -n "$icon" ]; then
    echo " $icon $output_text"
else
    echo " $output_text"
fi
