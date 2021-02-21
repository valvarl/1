#!/bin/bash

function listen {
	sleep 1
	this=$(<"chat$$")
	this=${this:4}
	printf "Handler PID: $this\n"
	p="pipe$this"
	mkfifo $p
	while :
	do
		msg=$(<$p)
		if [[ "$msg" = "pipe"* ]]
		then
			echo $msg > "chat$$"
			printf "The connection has been established.\n"
		else
			echo $msg
		fi
	done	
}

if [ "$1" = "connect" ]
then
	if [ "$2" = "" ]
	then
		printf "PID was expected as an option.\n"
	else

		listen &
		echo "pipe$!" > "chat$$"
		echo "pipe$!" > "pipe$2"
		to_pid="pipe$2"
		echo $p > $to_pid
		while :
		do
			read message
			if [ "$message" = "exit" ]
			then
				rm "chat$$"
				rm "pipe$!"
				kill $!
				break
			else
				echo $message > "$to_pid"
			fi
		done
	fi
elif [ "$1" = "mount" ]
then
	listen &
	echo "pipe$!" > "chat$$"
	while :
	do
		read message
		if [ "$message" = "exit" ]
		then
			rm "chat$$"
			rm "pipe$!"
			kill $!
			break
		else
			to_pid=$(<"chat$$")
			echo $message > "$to_pid"
		fi
	done
else
	printf "Usage:\n chat <command>\n\nCommands:\n mount\t\t\tMount a new process.\n connect <PID>\t\tConnect to an existing process.\n"
fi
