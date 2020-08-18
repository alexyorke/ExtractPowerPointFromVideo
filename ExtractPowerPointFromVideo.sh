#!/bin/bash
FILE="filename of the video you want to convert";
FFMPEG_DIR="/home/path/to/ffmpeg/ffmpeg-4.3.1-amd64-static";
IMAGE_DIR="images/";

NOISE=$($FFMPEG_DIR/ffmpeg -i "$FILE" -filter:v fps=fps=5 -vf "select='gte(scene,0)',metadata=print" -an -f null - 2>&1 | grep "Parsed_metadata_1" | cut -d "=" -f 2 | grep -E "^[0-9]+\.[0-9]+$" | sort -n | awk '{all[NR] = $0} END{print all[int(NR*0.95 - 0.5)]}');
$FFMPEG_DIR/ffmpeg -i "$FILE" -vf "freezedetect=n=$NOISE:d=1,metadata=mode=print" -map 0:v:0 -f null - 2>&1 | grep -Eo "freeze_start=([0-9\.])+" > /tmp/freeze.txt;
imagecount=0;
while read -r line; do $FFMPEG_DIR/ffmpeg -nostdin -ss "${line//[$'\t\r\n ']}" -i "$FILE" -vframes 1 -q:v 2 $IMAGE_DIR$imagecount.jpg; imagecount=$((imagecount+1)); done < <(cut -d "=" -f 2 /tmp/freeze.txt | sed 's/^/1000000*/' | bc -l | cut -d "." -f 1 | sed 's/$/us/');
