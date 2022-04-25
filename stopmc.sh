#!/bin/sh

#V3.1 update info.txt removal to screeninfo.txt and pid.txt | changed check value for service to "minecraft.server"

cd /opt/minecraft/mainsurvival

service_check () {
       	ps -ef | grep minecraft.server | grep -v grep | grep -v SCREEN | wc -l
}

screen -S minecraft -p 0 -X stuff "stop^M"
echo "stop command was passed"

#echo "sleeping for 15 seconds"
#sleep 15

echo "running loop check for service"
x=1
while [ $x != 0 ]
do
	x=$(service_check)
done

screen -S minecraft -p 0 -X stuff "exit^M"
echo "sent command to kill screen session"

#removing previous info file to indicate system is not running
sceeninfo_file=$(ls -l /opt/minecraft/mainsurvival/screeninfo.txt | wc -l)
pid_file=$(ls -l /opt/minecraft/mainsurvival/pid.txt | wc -l)
echo "number of screeninfo.txt is $screeninfo_file"
echo "number of pid.txt is $pid_file"

if [ $screeninfo_file -gt 0 ]
then
        echo "removing screeninfo.txt and pid.txt files"
        rm -f /opt/minecraft/mainsurvival/screeninfo.txt
	rm -f /opt/minecraft/mainsurvival/pid.txt
fi
