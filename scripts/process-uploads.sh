#!/bin/bash
PROJ_DIR=$(dirname $(dirname $0))

if [ $# -lt 1 ]; then
  echo "Usage: `basename $0` <camera>"
  exit 1
fi

CAMERA=$1
UPLOAD_DIR=$PROJ_DIR/upload/$CAMERA
IMAGES_DIR=$PROJ_DIR/cams/$CAMERA

inotifywait -mqr -e close_write --format '%f' "$UPLOAD_DIR" | while read filename
do
  filedate=$(date -r "$UPLOAD_DIR/$filename" +'%Y-%m-%d %H:%M:%S')
  montage -geometry +0+0 -background white -label "$filedate" "$UPLOAD_DIR/$filename" "$IMAGES_DIR/$filename"
  rm -f "$UPLOAD_DIR/$filename"
done
