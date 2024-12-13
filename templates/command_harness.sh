#!/usr/bin/env bash

HELP_MESSAGE_SPACING=35

# Generates help message given a function name
__help() {
    local help=$(declare -f "$1" | 
        while read -r l; do
            if [[ "$l" =~ :\ @help\ (.*) ]]; then
                printf "%s\n" "${BASH_REMATCH[1]}"
                break
            fi
        done
    )
    printf "%-${HELP_MESSAGE_SPACING}s %s\n" "$1" "$help"
}

__is_su() {
    local is_su=$(declare -f "$1" | 
        while read -r l; do 
            if [[ "$l" =~ :\ @su\ * ]]; then
                printf "True"
                break
            fi    
        done
    )

    if [[ $is_su == "True" && "$EUID" != 0 ]]; then 
        printf "\033[31mPlease run as root!:\033[0m\nsudo -E $0 $1\n"
        exit 1
    fi
}

if [[ $# == 0 ]]; then
    cmds=$(compgen -A function | sed /^__*/d)
    printf "\033[31mError! No Command Selected!\033[0m\n\nRun script using $0 <cmd> [args]\n\n\033[32mCommands:\033[0m\n"
    for cmd in ${cmds[@]}; do
        __help "$cmd"
    done
else
    CMD="$1"
    shift
    if [[ $(type -t "$CMD") == "function" ]]; then
        __is_su "$CMD"
        $CMD $@
    else 
        printf "\033[31m$CMD is not a valid command!\033[0m\n";
    fi
fi
