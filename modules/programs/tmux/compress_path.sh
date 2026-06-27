#!/bin/bash
# Shared path compression utility for tmux window titles and Zsh hooks.

compress_path() {
    local path
    if [[ $# -eq 0 ]]; then
        path="${PWD:-}"
    else
        path="${1:-}"
    fi

    if [[ -z "$path" ]]; then
        printf "\n"
        return
    fi

    # Strip trailing slashes unless path is root "/"
    while [[ "$path" != "/" && "$path" == */ ]]; do
        path="${path%/}"
    done

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
                printf "%s\n" "($workspace:$effective_dir_type)"
                return
            elif [[ "$rest" == */* ]]; then
                printf "%s\n" "($workspace:$effective_dir_type)//.../${rest##*/}"
                return
            else
                printf "%s\n" "($workspace:$effective_dir_type)//$rest"
                return
            fi
        fi
    fi

    # Replace $HOME with ~
    if [[ -n "${HOME:-}" && "${HOME:-}" != "/" ]]; then
        local home_dir="${HOME:-}"
        home_dir="${home_dir%/}"
        if [[ -n "$home_dir" ]]; then
            if [[ "$path" == "$home_dir" ]]; then
                path="~"
            elif [[ "$path" == "$home_dir/"* ]]; then
                path="~${path#$home_dir}"
            fi
        fi
    fi

    # Shorten intermediate directories (e.g., ~/projects/my-app -> ~/.../my-app)
    if [[ "$path" == ~* ]]; then
        if [[ "$path" == ~*/*/* ]]; then
            local tilde_prefix="${path%%/*}"
            printf "%s\n" "${tilde_prefix}/.../${path##*/}"
        else
            printf "%s\n" "$path"
        fi
        return
    fi

    if [[ "$path" == /* ]]; then
        if [[ "$path" == /*/* ]]; then
            printf "%s\n" "/.../${path##*/}"
        else
            printf "%s\n" "$path"
        fi
        return
    fi

    if [[ "$path" == */* ]]; then
        printf "%s\n" ".../${path##*/}"
    else
        printf "%s\n" "$path"
    fi
}
