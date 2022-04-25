#!/bin/sh
#V1 created main script to start minecraft server
#V2 added logging and corrected screen commands
#V3 changed info_file to create separate pid file for "Type=forking" in unit. pause to wait to create pid file.

cd /opt/minecraft/mainsurvival/

#mincraft_world=$null

timestamp() {
	date +"%Y%m%d_%H:%M:%S"
}

#grabs the PID for the minecrat process and screen pid/name
create_info_file() {

	echo "$(ps -ef | grep minecraft | grep java | awk {'print $2'})" >> /opt/minecraft/mainsurvival/pid.txt
	echo "SCREEN= $(screen -ls | grep minecraft | awk {'print $1'})" >> /opt/minecraft/mainsurvival/screeninfo.txt
}

service_check () {
        ps -ef | grep mine | grep -v grep | grep -v SCREEN | wc -l
}

#removing previous startup log
startlog=$(ls -l /opt/minecraft/mainsurvival/startup.log | wc -l)
echo "number of startup.log files is $startlog"

if [ $startlog != 0 ]
then
        echo "removing statup.log file"
        rm -f /opt/minecraft/mainsurvival/startup.log
fi

#starting new startup log
echo "$(timestamp): Script beginning run"  > /usr/games/minecraft/startup.log

#making sure no screen for service exists, if it does, script exits with error in startup log
screen_run=$(screen -list | grep minecraft | wc -l)
echo "$(timestamp): Number of running instances of screen with the name of minecraft $screen_run" >> /opt/minecraft/mainsurvival/startup.log

if [ $screen_run != 0 ]
	then
                echo "$(timestamp): There was already a screen with the name minecraft running" >> /opt/minecraft/mainsurvival/startup.log
                exit
	
	else
                screen -d -m -S minecraft
                echo "$(timestamp): screen with the name minecraft started in disconneded mode" >> /opt/minecraft/mainsurvival/startup.log

	fi

#providing time for screen to start
echo "Sleep for 1 second" >> /opt/minecraft/mainsurvival/startup.log
sleep 1

#checks if screen is running before executing server start command
screen_chk=$(screen -list | grep minecraft | wc -l)
echo "$(timestamp): output of screen_chk value = $screen_chk" >> /opt/minecraft/mainsurvival/startup.log
if [ $screen_chk = 1 ]
	then
		screen -S minecraft -p 0 -X stuff '/usr/bin/java -Xmx1024M -Xms1024M -jar /opt/minecraft/mainsurvival/minecraft.server nogui^M'
		echo "$(timestamp): Command to execute minecraft server .jar block" >> /opt/minecraft/mainsurvival/startup.log
	else
		echo "$(timestamp): screen_chk did not = 1" >> /opt/minecraft/mainsurvival/startup.log
	fi

#get info about running process
SRVRUN=$(ps -ef | grep minecraft.server | grep -v grep)
echo "$(timestamp): ps output: $SRVRUN" >> /opt/minecraft/mainsurvival/startup.log

#run funtion to create info file with PID and Screen info
echo "running loop check for service"
x=0
while [ $x -gt 0 ]
do
        x=$(service_check)
done

#echo "creating pid and screeninfo files"
create_info_file
