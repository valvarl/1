#!/bin/bash

touch passwdCopy.txt
cat /etc/passwd > passwdCopy.txt
cat passwdCopy.txt
user=$""
while :
do
	if [[ "$user" == "" ]]; then
		echo "Enter which user you want to make the change for: "
		read user
	fi
	check=$(grep "^$user:" passwdCopy.txt)
	if [[ "$check" == "" ]]; then
		echo "No such user"
		user=""
		continue
	else
		echo $check
	fi
	echo "To select the parameter you want to change, enter the corresponding number:
		[ 1 ] Username
		[ 2 ] Full user name
		[ 3 ] Room number
		[ 4 ] Work phone
		[ 5 ] Home phone
		[ 6 ] Additional info
		[ 7 ] Home directory
		[ 8 ] Default Shell"
	read workToDo
	if [[ "$workToDo" == "1" ]]; then
		echo "What do you want to exchange it for?" 
		while :
		do
		read toChange
		if [[ "$toChange" == "" ]]; then
			echo "You entered an empty string, this parameter must take a value"
		else 
			break
		fi
		done
		sed -i "s|^$user:|$toChange:|" passwdCopy.txt
		grep "^$toChange:" passwdCopy.txt
		user=$toChange
	elif [[ "$workToDo" -ge "2" ]] && [[ "$workToDo" -le "6" ]]; then
		echo "What do you want to exchange it for?" 
		read toChange
		gecos=($(grep "^$user:" passwdCopy.txt | awk -F ":" '{print $5}'))
		if [[ "$workToDo" == "2" ]]; then
			newGecos="$(echo $toChange,$gecos | awk -F "," '{$2=$1; print $2","$3","$4","$5}')"
		elif [[ "$workToDo" == "3" ]]; then
			newGecos="$(echo $toChange,$gecos | awk -F "," '{$3=$1; print $2","$3","$4","$5}')"
		elif [[ "$workToDo" == "4" ]]; then
			newGecos="$(echo $toChange,$gecos | awk -F "," '{$4=$1; print $2","$3","$4","$5}')"
		elif [[ "$workToDo" == "5" ]]; then
			newGecos="$(echo $toChange,$gecos | awk -F "," '{$5=$1; print $2","$3","$4","$5}')"
		fi			
		oldRow=$(grep "^$user:" passwdCopy.txt) 
		newRow=$(grep "^$user:" passwdCopy.txt | sed "s|:$gecos:|:$newGecos:|")
		sed -i "s|$oldRow|$newRow|g" passwdCopy.txt
		grep "^$user:" passwdCopy.txt
	elif [[ "$workToDo" == "7" ]] || [[ "$workToDo" == "8" ]]; then
		echo "What do you want to exchange it for?" 
		while :
		do
		read toChange
		if [[ "$toChange" == "" ]]; then
			echo "You entered an empty string, this parameter must take a value"
		else 
			break
		fi
		done
		if [[ "$workToDo" == "7" ]]; then
			oldData=($(grep "^$user:" passwdCopy.txt | awk -F ":" '{print $6}'))
		else
			oldData=($(grep "$user" passwdCopy.txt | awk -F ":" '{print $7}'))
		fi
		oldRow=$(grep "^$user:x" passwdCopy.txt)
		newRow=$(grep "^$user:x" passwdCopy.txt | sed "s|$oldData|$toChange|")
		sed -i "s|$oldRow|$newRow|g" passwdCopy.txt
		grep "^$user" passwdCopy.txt
	else 
		echo "Incorrect input"
		continue
	fi
echo "To choose to continue working with the program, enter the corresponding number:
	[ 1 ] Continue changing the same user
	[ 2 ] Change another user
	[ 3 ] End program operation"
	read workToDo
	if [[ "$workToDo" == "1" ]]; then
		continue
	elif [[ "$workToDo" == "2" ]]; then
		user=""
		continue
	elif [[ "$workToDo" == "3" ]]; then
		break
	else
		cat passwdCopy.txt
		user=$""
	fi
done
