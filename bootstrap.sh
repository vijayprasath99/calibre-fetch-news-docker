#!/bin/bash
# This is free and unencumbered shell script released into the public domain.
#

####################### Begin Customization Section #############################

# Base location for download script
BASEDIR="$HOME"
DOWNLOAD_SCRIPT_NAME="fetch-news.sh"
OUTDIR="$HOME/news"

LOG_FILE="$HOME/news.log"

######################## End Customization Section #############################

DOWNLOADSCRIPT="$BASEDIR/$DOWNLOAD_SCRIPT_NAME"

# Create the output directory
mkdir -p $OUTDIR
touch $LOG_FILE

chmod +x $DOWNLOADSCRIPT
touch /tester.log
echo "* 8 * * * $DOWNLOADSCRIPT >> $LOG_FILE" > /etc/cron.daily/newscron

crontab /etc/cron.daily/newscron
