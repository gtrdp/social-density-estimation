#!/usr/bin/env bash
# script to sort the gopro images into separate folders
# how it works:
# - loop for total minutes
# - in each loop copy total file count files to the folder
# - separate each files from different gopros

# read arguments
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

# main loop in minutes
cd $DIR
for i in `seq 1 30`;
do
    echo $i

    mkdir $i
	# loop for each gopro
	for gp in $DIR/*
	do
		if [ -d "$gp" ] && [[ "$gp" == *"gp"* ]]; then
            mkdir $i/$(basename "$gp")
			index=1
            cd $(basename "$gp")
            for filename in *;
            do
                if [ $index -lt 13 ] # 13 comes from 12 pictures per minute plus 1
                then
                    mv $filename ../$i/$(basename "$gp")/
                    index=$((index+1))
                fi
            done
            cd ..
		fi
	done
done
