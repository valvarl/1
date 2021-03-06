#!/bin/bash

function get_message {
	msg=$(<"tmp.txt")
	if [[ "$msg" = "pid"* ]]
	then
		to_pid=${msg:3}
		echo "The connection has been established."
	else
		echo $msg
	fi
}

function post_message {
	read message
	while :
	do
		echo "$message" > "tmp.txt"
		kill -14 "$to_pid"
		read message
	done
}

trap 'get_message' SIGALRM
trap 'rm -f tmp.txt; exit 1' 1 2 3 15

if [ "$1" = "connect" ]
then
	if [ "$2" = "" ]
	then
		printf "PID was expected as an option.\n"
	else
		to_pid=$2
		echo "pid$$" > "tmp.txt"
		kill -14 "$to_pid"
		post_message
	fi
elif [ "$1" = "mount" ]
then
	echo "PID: $$"
	to_pid=$$
	post_message
else
	printf "Usage:\n simple_chat <command>\n\nCommands:\n mount\t\tMount a new process.\n connect <PID>\t\tConnect to an existing process.\n"
fi
