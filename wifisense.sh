#!/bin/bash
# script to automate capturing wifi probe request and available accesspoint

# How it works
# 0. read the location name from the arguments
# 1. capture wifi probe-request packets for scan_duration minutes, save it to dump file
#    with current timestamp
# 2. kill the script to stop capturing the probe-request packets
# 3. start counting the available accesspoint and save it to a file with
#    current timestamp
# 4. repeat step 1 to 3 until the program receives SIG kill
#
# PS. always output what is happening now, and give current timestamp

# read location arguments
if [ $# -eq 0 ]
	then
		echo ""
		echo "No arguments supplied. Exiting..."
		echo "Example: ./wifisense.sh grotemarkt 12 300"
		echo ""
		# exit
		exit 1
	elif [ $# -eq 3 ]; then
	 	#statements 
		location_name=$1
		let "max_loop=$2 + 1"
		sleep_time=$3
	else
		echo ""
		echo "Wrong number of arguments supplied. Exiting..."
		echo "Example: ./wifisense.sh grotemarkt 12 300"
		echo ""
		# exit
		exit 1
fi

loop=1
# main loop
while [ $loop -lt $max_loop ]; do
	current_date=$(date +%Y%m%d-%H.%M)
	echo ""
	echo "===============Loop: "$loop" - "$current_date" ==============="
	# capture probe request packets in background
	# prepare the file name
	file_name=$location_name-pr-$current_date.pcap
	echo ""
	echo "Capturing WiFi probe-request packets..."
#	sudo airport --channel=1
	tcpdump -In -i en0 -e -s 256 type mgt subtype probe-req -w $file_name &

	# start recording the sound
	echo ""
	echo "Recording wav audio..."
	audio_name=$location_name-au-$current_date.wav
	# run SoX
	sox -dq -b 8 -r 8000 $audio_name & 

	# wait for scan_duration
	sleep $sleep_time 
	# kill the previous process
	echo ""
	echo "Killing the capturing process..."
	killall tcpdump inotifywait

	echo ""
	echo "Killing the sound recording process..."
	killall sox inotifywait


    # sleep for 2 sec to make everything a bit stable
    sleep 2

	# logging available accesspoint
	# prepare the file name
    # ============= do this twice! =========================
    # as the first scanning might be unstable
	file_name=$location_name-ap-$current_date.txt
	echo ""
	echo "Logging available Access Point..."
	airport -s >> $file_name
	airport -s >> $file_name

	echo ""
	echo "Done."
	echo "Continue next loop..."
	loop=$((loop+1))
done

echo ""
echo "Max loop reached. Terminating..."

#START_TIME=$SECONDS
#dosomething
#ELAPSED_TIME=$(($SECONDS - $START_TIME))
