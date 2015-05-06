#!/bin/bash

#######################################################################
# make-timelapse.sh
#
# creates timelapse movies for archival from a selected
# set of snapshot images uploaded from  a security camera.
#
# images are expected to be found under <PROJ_DIR>/cams/<CAMERA>
# generated timelapse movies will end up in <PROJ_DIR>/videos/<CAMERA>
#######################################################################

IMAGE_RATE=10
PROJ_DIR=$(dirname $(dirname $0))
LOG_DIR=$PROJ_DIR/logs
mkdir -p $LOG_DIR


log() {
  echo "`date "+%Y%m%d %H:%M.%S"` - $1 - $2" >> $LOG_DIR/`date "+%Y%m%d"`.log
}

error() {
	echo "$1"
  log "ERROR" "$1"
	exit 1
}

info() {
  echo "$1"
  log "INFO" "$1"
}

if [ $# -lt 1 ]; then
  error "Usage: `basename $0` <camera> [date]"
fi

CAMERA=$1
IMAGES_DIR=$PROJ_DIR/cams/$CAMERA
VIDEO_DIR=$PROJ_DIR/videos/$CAMERA
TEMP_DIR=/tmp/$CAMERA

if [ ! -d $IMAGES_DIR ]; then
  error "No camera directory for camera '$CAMERA' found"
fi

mkdir -p $VIDEO_DIR
mkdir -p $TEMP_DIR
rm -f $TEMP_DIR/*

if [ -z "$2" ]; then
  GENERATE_DATE=$(date +%Y%m%d%H -d "1 hour ago")
else
  GENERATE_DATE=$2
fi

IMAGES_WILDCARD=$CAMERA-$GENERATE_DATE*.jpg

info "generating timelapse movie for camera '$CAMERA' at $GENERATE_DATE using images in $IMAGES_DIR"

# rename camera photos using sequence numbering
a=1
for i in $IMAGES_DIR/$IMAGES_WILDCARD; do
  new="$TEMP_DIR/`printf "%04d.jpg" "$a"`"
  cp -- "$i" "$new"
  let a=a+1
done

# generate movie
avconv -y -r $IMAGE_RATE -i $TEMP_DIR/%4d.jpg -r $IMAGE_RATE -vcodec libx264 -q:v 3 -vf scale=iw:ih $TEMP_DIR/$CAMERA-$GENERATE_DATE.mp4;

# move finished mp4 video to video dir
mv $TEMP_DIR/$CAMERA-$GENERATE_DATE.mp4 $VIDEO_DIR

# copy first image to use as poster
cp $TEMP_DIR/0001.jpg $VIDEO_DIR/$CAMERA-$GENERATE_DATE.jpg

# remove images
find $IMAGES_DIR -maxdepth 1 -name "$IMAGES_WILDCARD" -print0 | xargs -0 rm

# set permissions
chmod 644 $VIDEO_DIR/$CAMERA-$GENERATE_DATE.*

# clean up temp dir
rm -Rf $TEMP_DIR
