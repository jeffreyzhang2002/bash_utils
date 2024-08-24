#!/usr/bin/env bash

# Automatically generate high level auto completion trigger by sourcing this file first
# source <filename>

if [[ ${BASH_SOURCE[0]} != ${0} ]] && [[ -z "${SECRET_SOURCE}" ]]; then
    SCRIPT_FUNCTIONS=$(
        export SECRET_SOURCE="true"; 
        ./${BASH_SOURCE[0]}; 
    )

    __completion() {        
        CURR_WORD="${COMP_WORDS[COMP_CWORD]}"

        if [[ $COMP_CWORD == 1 ]]; then
            COMPREPLY=( $(compgen -W "${SCRIPT_FUNCTIONS}" -- "$CURR_WORD") )
        fi

        return 0
    }

    complete -o nospace -F __completion $(basename ${BASH_SOURCE[0]})
    return 0
fi


# Global Variables
# _________________________________________

# Directory we want to force this command to always run as. We usually use git root
CD_DIR=${CD_DIR:$(git rev-parse --show-toplevel)}
HELP_MESSAGE_SPACING=35

# Private Functions
# ------------------------------------------

__printf() {
    if [[ -z "$QUIET" ]]; then
        printf "$@"
    fi
}

# Check if a command requires sudo and checks if command has root abilities
__is_sudo() {
    out=$(declare -f $1 | awk '
        NR>2 {
            if($1 != ":") {
                exit
            } else if ($2 == "@sudo;") {
                print 0; exit
            }
        }')

    if [[ $out == "0" && "$EUID" != 0 ]]; then 
        __printf "\033[31mPlease run as root!:\033[0m\nsudo -E $0 $1\n"
        exit
    fi
}

# Generates Help Messages from commands
__help() {
    help=$(declare -f $1 | awk ' 
        NR>2 {
            if ( $1 != ":") { 
                exit 0 
            } else if ($2 == "@help" ) { 
                for(i = 3; i < NF; i++){ 
                    printf "%s ", $i 
                }
                printf "%s ", substr($NF, 1, length($NF)-1)
            }
        }')
    printf "%-${HELP_MESSAGE_SPACING}s %s\n" "$1" "$help"
}

# Terminal Colors
if [[ ${TERM} != "dumb" ]]; then
    RED=$(tput setaf 1)
    GREEN=$(tput setaf 2)
    YELLOW=$(tput setaf 3)
    BLUE=$(tput setaf 4)
    MAGENTA=$(tput setaf 5)
    CYAN=$(tput setaf 6)
    RESET=$(tput init)
    BOLD=$(tput bold)
    NORMAL=$(tput sgr0)
fi


# Custom Commands Start Here
# -------------------------------------------

function example_function {
: @help Example Function Help Message
    echo "Commands 1"


}

function example_function_requires_sudo {
: @help This requires sudo
: @sudo

    echo "Commands 2"

}


# Code used to run the functions
# -----------------------------------------

if [[ -n "$SECRET_SOURCE" ]]; then
    compgen -A function | sed /^__*/d
    exit 0
fi

if [[ $# == 0 ]]; then
    cmds=$(compgen -A function | sed /^__*/d)
    __printf "\033[31mError! No Command Selected!\033[0m\nRun Script Using sudo -E $0 <cmd> [args]\n\n\033[32mCommands:\033[0m\n"
    for cmd in ${cmds[@]}; do
        __help $cmd
    done
else
    CMD=$1

    shift
    if [[ $(type -t $CMD) == "function" ]]; then
        cd $CD_DIR
        __is_sudo $CMD
        $CMD $@
    else 
        __printf "\033[31m$CMD is not a valid command!\033[0m\n";
    fi
fi
