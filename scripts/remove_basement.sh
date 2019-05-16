#!/bin/sh
GENERATE_DATE=$(date +%Y%m%d%H -d "1 hour ago")
find /opt/securicam/upload/basement/ -maxdepth 1 -name "basement-$GENERATE_DATE*.jpg" -print0 | xargs -0 rm
