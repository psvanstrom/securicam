#!/bin/bash

if [ $# -lt 1 ]
then
  echo "Usage: `basename $0` <camera> [days old]"
  exit
fi

WORKDIR=$(dirname $(dirname $0))
CAMERA=$1

if [ -z "$2" ] 
then
  DAYS_OLD=7
else
  DAYS_OLD=$2
fi

VIDEO_PATH=$WORKDIR/videos/$CAMERA/

find $VIDEO_PATH -mtime +$DAYS_OLD -exec rm {} \;
