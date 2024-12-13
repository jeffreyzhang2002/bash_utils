
# Export commonly used colors for easy. Moreover we also add a color function to generate RGB colors

export FG_BLACK=$(tput setaf 0)
export FG_RED=$(tput setaf 1)
export FG_GREEN=$(tput setaf 2)
export FG_YELLOW=$(tput setaf 3)
export FG_BLUE=$(tput setaf 4)
export FG_MAGENTA=$(tput setaf 5)
export FG_CYAN=$(tput setaf 6)
export FG_WHITE=$(tput setaf 7)
export FG_RESET=$(tput setaf 9)

export BG_BLACK=$(tput setab 0)
export BG_RED=$(tput setab 1)
export BG_GREEN=$(tput setab 2)
export BG_YELLOW=$(tput setab 3)
export BG_BLUE=$(tput setab 4)
export BG_MAGENTA=$(tput setab 5)
export BG_CYAN=$(tput setab 6)
export BG_WHITE=$(tput setab 7)
export BG_RESET=$(tput setab 9)

export BOLD=$(tput bold)
export RESET=$(tput sgr0)

function __FG_RGB {
    printf "\e[38;2;%s;%s;%sm" "$1" "$2" "$3"
}

function __BG_RGB {
    printf "\e[48;2;%s;%s;%sm" "$1" "$2" "$3"
}
