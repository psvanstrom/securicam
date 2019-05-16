#!/bin/bash
PROJ_DIR=$(dirname $(dirname $0))

if [ $# -lt 2 ]; then
  echo "Usage: `basename $0` <camera> <cam-id>"
  exit 1
fi

CAMERA=$1
FOSCAM_ID=$2
UPLOAD_DIR=$PROJ_DIR/upload/$CAMERA/$FOSCAM_ID/snap
IMAGES_DIR=$PROJ_DIR/cams/$CAMERA

inotifywait -mqr -e close_write --format '%f' "$UPLOAD_DIR" | while read filename
do
  rename 's/Schedule_(\d{8})-(\d{6}).*$/garage-${1}${2}01\.jpg/' $UPLOAD_DIR/$filename
  mv $UPLOAD_DIR/garage-*.jpg $IMAGES_DIR
done
