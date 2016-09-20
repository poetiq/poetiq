#!/bin/bash

log () {
	if [ ! -f $3 ]; then
		touch $3
	fi
	printf "%s |%s| %s[%s] | - %s\n" "$(date +%Y.%m.%dT%T.%3N)" "${1-INFO}" "$0" $$ "$2" | tee -a $3
}

logerr () {
	log "ERROR" "$1" ${2-${LOG_FILE}}
}

logwarn () {
	log "WARN" "$1" ${2-${LOG_FILE}}
}

loginfo () {
	log "INFO" "$1" ${2-${LOG_FILE}}
}

logconsoleerr () {
	echo -e "\033[0;31m$1\033[0m"
}

export -f logerr
export -f logwarn
export -f loginfo
export -f logconsoleerr
