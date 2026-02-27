#!/bin/bash

# Trim spaces just in case tmux pads pane_title
pane_title=$(echo "$1" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
window_name=$(echo "$2" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
pane_current_path=$(echo "$3" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

host_name=$(hostname)
host_short=$(hostname -s)

compress_path() {
    local path="$1"
    # Replace $HOME with ~
    if [[ "$path" == "$HOME"* ]]; then
        path="~${path#$HOME}"
    fi

    # Shorten intermediate directories (e.g., ~/projects/my-app -> ~/p/my-app)
    # This logic splits by / and shortens all but the last component
    local IFS='/'
    read -ra ADDR <<< "$path"
    local len=${#ADDR[@]}
    local compressed=""
    for (( i=0; i<len; i++ )); do
        if [[ $i -eq $((len-1)) ]]; then
            compressed+="${ADDR[$i]}"
        elif [[ $i -eq 0 && "${ADDR[$i]}" == "~" ]]; then
            compressed+="${ADDR[$i]}"
        elif [[ -z "${ADDR[$i]}" ]]; then
            # Handle leading slash
            compressed+=""
        else
            compressed+="${ADDR[$i]:0:1}"
        fi
        if [[ $i -lt $((len-1)) ]]; then
            compressed+="/"
        fi
    done
    echo "$compressed"
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
        jj|lazyjj|svn) echo "" ;;
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

if [[ "$base_name" == "zsh" && -n "$pane_current_path" ]]; then
    output_text=$(compress_path "$pane_current_path")
fi

if [ -n "$icon" ]; then
    echo " $icon $output_text"
else
    echo " $output_text"
fi
