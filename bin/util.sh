#!/bin/bash

# http://stackoverflow.com/questions/4332478/read-the-current-text-color-in-a-xterm/4332530#4332530
NORMAL=$(tput sgr0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
# BLACK=$(tput setaf 0)
# BLUE=$(tput setaf 4)
# MAGENTA=$(tput setaf 5)
# CYAN=$(tput setaf 6)
# WHITE=$(tput setaf 7)
# LIME_YELLOW=$(tput setaf 190)
POWDER_BLUE=$(tput setaf 153)
# BRIGHT=$(tput bold)
# BLINK=$(tput blink)
# REVERSE=$(tput smso)
UNDERLINE=$(tput smul)

log () {
	if [ ! -f $3 ]; then touch $3; fi
	printf "%s |%s| %s[%s] | - %s\n" "$(date +%Y.%m.%dT%T.%3N)" "${1-INFO}" "$0" $$ "$2" | tee -a $3
}

logerr () {
	log "${RED}ERROR${NORMAL}" "$1" ${2-${LOG_FILE}}
}

logwarn () {
	log "${YELLOW}WARN${NORMAL}" "$1" ${2-${LOG_FILE}}
}

loginfo () {
	log "${GREEN}INFO${NORMAL}" "$1" ${2-${LOG_FILE}}
}

export -f logerr
export -f logwarn
export -f loginfo
