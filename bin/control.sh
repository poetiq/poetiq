#!/bin/bash

BIN="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
source $BIN/util.sh
source $BIN/setenv.sh

# exit script or send interrupt signal to stop execution of function if in console mode
function exit_or_return ()
{
	if [ -z "$PS1" ]; then exit $1; else kill -INT $$; fi
}

function check_cfg_exists ()
{
	if [ ! -f $KDBCONFIG/start.cfg ]; then
		local m="Config file $KDBCONFIG/start.cfg not found"
		if [ ${FUNCNAME[1]} == "show" ]; then
			logerr "$m"
		else
			logerr "$m"
		fi
		exit 1
	fi
}

function get_procs ()
{
	check_cfg_exists
	tail -n +2 $KDBCONFIG/start.cfg | cut -d ',' -f 1,2
}

function get_params ()
{
	LOGLEVEL=""; DEBUG=0
	caller=${FUNCNAME[1]}
	if [ $# -lt 2 ]; then ${caller}_usage $caller; fi

	while (( "$#" )); do
		case "$1" in
			-p) # get proc type and proc name
				if [ -z "$2" ]; then ${caller}_usage $caller; fi
				PROCTYPE=$2
				PROCNAME=$3
				if [ -z "${PROCTYPE}" ] || [ -z "${PROCNAME}" ]; then
					logerr "Process not found"
					return 2
				fi
				shift 3
			;;
			-w) # get workspace size
				if [ -z "$2" ]; then ${caller}_usage $caller; fi
				W="$1 $2"
				shift 2
			;;
			-g) # garbage collect
				if [ -z "$2" ]; then ${caller}_usage $caller; fi
				G="$1 $2"
				shift 2
			;;
			--debug) # run process in foreground
				DEBUG=1
				shift
			;;
			--log) # get log level
				if [ -z "$2" ]; then ${caller}_usage $caller; fi
				LOGLEVEL="$1 $2"
				shift 2
			;;
			*) ${caller}_usage $caller;;
		esac
	done
	if [ $? -eq 2 ]; then return 2; fi
}

function get_cmd()
{
	local cmd=""
	cmd=$(grep "$PROCTYPE,$PROCNAME" $KDBCONFIG/start.cfg | cut -d ',' -f 3)
	if [[ ! "$OSTYPE" =~ *win* ]]; then
		if [ $DEBUG -eq 0 ]; then
			CMD="nohup q $cmd </dev/null >$KDBLOG/$PROCNAME 2>&1 &"
		else
			CMD="q $cmd -debug"
		fi
	else
		CMD="q $cmd -new_console:t:'$PROCNAME'"
	fi
	CMD=$(eval echo \""${CMD}"\")
}

# main start function
function startp ()
{
	get_params $*
	if [ $? -eq 2 ]; then return 0; fi
	starth
}

function starth ()
{
	check_cfg_exists
	queryh
	if [ -n "$PID" ]; then
		logwarn "Process $(procname) is already running. Use restart if you want to restart the process"
		return 0
	fi
	get_cmd

	if [ $DEBUG -eq 0 ]; then
		loginfo "Starting process $(procname) in the background:"
	else
		loginfo "Starting process $(procname) in the foreground:"
	fi
	echo $CMD
	eval $CMD
}

function startp_usage ()
{
	echo -e "Usage:"
	echo -e "\t${1} -p <proctype> <procname> [-w <size>] [--log <loglevel>] [--debug]"
	exit_or_return 1
}

# main query function
function queryp ()
{
	get_params $*
	if [ $? -eq 2 ]; then return 0; fi
	queryh
	if [ -z "$PID" ]; then
		logerr "$(procname) is not running"
		return 0
	else
		loginfo "$(procname) is running with PID $PID"
		return 1
	fi
}

function queryh ()
{
	unset PID
	if [[ "$OSTYPE" =~ darwin* ]]; then
		PID=$(ps -e -o 'pid,args' | grep -E "\-(proctype.*procname)" | grep m32 | grep "$PROCTYPE" | grep "$PROCNAME" | awk '{print $1}')
	elif [ "$OSTYPE" == "cygwin" ]; then
		PID=$(pstree -pal | grep -E "\-(proctype.*procname)" | grep -v grep | grep -F "$PROCTYPE" | grep -F "$PROCNAME" | awk -F, '{print $2)' | awk '{print $1}')
	else
		PID=$(ps -elf | grep -E "\-(proctype.*procname)" | grep -E "l32|l64" | grep "$PROCTYPE" | grep "$PROCNAME" | awk '{print $4}')
	fi
}

# main stop function
function stopp ()
{
	get_params $*
	if [ $? -eq 2 ]; then return 0; fi
	stoph
}

function stoph ()
{
	queryh
	if [ -n "$PID" ]; then
		loginfo "Stopping $(procname)"
		if [ "$OSTYPE" == "cygwin" ]; then
			kill $PID
		else
			# TODO: Exit more gracefully
			kill $PID
		fi
	fi
}

function stopallp ()
{
	echo "Not yet implemented"
}

function queryp_usage ()
{
	echo -e "Usage:"
	echo -e "\t${1} -p <proctype> <procname>"
	exit_or_return 1
}

function stopp_usage ()
{
	echo -e "Usage:"
	echo -e "\t${1} -p <proctype> <procname>"
	exit 1
}

function restartp ()
{
	get_params $*
	if [ $? -eq 2 ]; then return 0; fi
	stoph
	starth
}

function restartp_usage ()
{
	startp_usage $1
}

function procname ()
{
	echo "${POWDER_BLUE}<${PROCTYPE},${PROCNAME}>${NORMAL}"
}

export -f queryp
export -f startp
export -f stopp
export -f stopallp
