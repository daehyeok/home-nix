#!/bin/bash

# Trim spaces just in case tmux pads pane_title
pane_title=$(echo "$1" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
window_name=$(echo "$2" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

host_name=$(hostname)
host_short=$(hostname -s)

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

if [ -n "$icon" ]; then
    echo " $icon $base_name"
else
    echo " $base_name"
fi
