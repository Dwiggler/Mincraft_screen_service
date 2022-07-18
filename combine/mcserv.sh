#!/bin/sh
#v0.1

#get command flag passed

ARG=$(echo $1 | tr '[:upper:]' '[:lower:]')

#relocate to working WorkingDirectory
cd /opt/minecraft/mainsurvival/

#for creating time stamps on log files
timestamp() {
	date +"%Y%m%d_%H:%M:%S"
}

#grabs the PID for the minecrat process and screen pid/name
create_info_file() {

	echo "$(ps -ef | grep minecraft | grep java | awk {'print $2'})" >> /opt/minecraft/mainsurvival/pid.txt
	echo "SCREEN= $(screen -ls | grep minecraft | awk {'print $1'})" >> /opt/minecraft/mainsurvival/screeninfo.txt
}
