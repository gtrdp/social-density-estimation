#!/usr/bin/env bash
# script to read pcap files and save it to txt files

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
for i in pcap/*.pcap;
do
    FOO=$(basename $i)
    FOO=${FOO%.*}
    tcpdump -en -r pcap/$(basename $i) >>raw/$FOO.txt
done
