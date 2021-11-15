#!/bin/bash

if ! options=$( getopt -o a:bh -l hello,help,name: -- "$@" )
then
	echo "ERROR!!"
	exit 1
fi

eval set -- "$options"

while true
do
	case "$1" in
		-h|--help)
		echo "help() excute"
		shift ;;
		-a|--name)
		name=$2
		echo "hello $name!!"
		shift 2 ;;
		-b|--hello)
		echo "Hello World!!"
		shift ;;
		--)
		shift 2
		break
	esac
done
