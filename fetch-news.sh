#!/bin/bash
# This is free and unencumbered shell script released into the public domain.
#

####################### Begin Customization Section #############################
#
# Name of the recipe to fetch. You can run:
#     ebook-convert --list-recipes
# to look for the correct name. Do not forget the .recipe suffix
RECIPE="The Hindu.recipe"
OUTDIR="$HOME/news"

# Select your output profile. See http://manual.calibre-ebook.com/cli/ebook-convert-14.html
# for a list. Common choices: kindle, kindle_dx, kindle_fire, kobo, ipad, sony
OUTPROFILE="kindle"

# A text file with an email per line. This script will send an email to each one.
# You can set it to "" to not send any email
EMAILSFILE="$HOME/email-list.txt"

# Your SMTP credentials
SMTP="$CALIBRE_SMTP"
PORT="$CALIBRE_PORT"
USER="$CALIBRE_USER"
PASSWD="$CALIBRE_PASS"
FROM="$CALIBRE_FROM"

# A prefix for the emails' subject. The date will be appended to it.
SUBJECTPREFIX="News: The Hindu"
# A prefix for the emails' content. The date will be appended to it.
CONTENTPREFIX="Attached is your periodical downloaded by calibre from hindu"
# A prefix for generate file. The date will be appended to it.
OUTPUTPREFIX="the_hindu_"
#
######################## End Customization Section #############################

DATEFILE=`date "+%Y_%m_%d"`
DATESTR=`date "+%Y/%m/%d"`
OUTFILE="${OUTDIR}/${OUTPUTPREFIX}${DATEFILE}.mobi"

echo "Fetching $RECIPE into $OUTFILE"
ebook-convert "$RECIPE" "$OUTFILE" --output-profile "$OUTPROFILE" 

# Change the author of the ebook from "calibre" to the current date. 
# I do this because sending periodicals to a Kindle Touch is removing
# the periodical format and there is no way to differentiate between
# two editions in the home screen. This way, the date is shown next 
# to the title.
# See http://www.amazon.com/forum/kindle/ref=cm_cd_t_rvt_np?_encoding=UTF8&cdForum=Fx1D7SY3BVSESG&cdPage=1&cdThread=Tx1AP36U78ZHQ1I
# and, please, email amazon (kindle-feedback@amazon.com) asking to add 
# a way to keep the peridiocal format when sending through @free.kindle.com 
# addresses
echo "Setting date $DATESTR as author in $OUTFILE"
ebook-meta -a "$DATESTR" "$OUTFILE"

# email the files
if [ -n "$EMAILSFILE" -a -f "$EMAILSFILE" ]; then
    for TO in `cat $EMAILSFILE`; do
	echo "Sending $OUTFILE to $TO"
	calibre-smtp --attachment "$OUTFILE" --relay "$SMTP" --port "$PORT" --username "$USER" --password "$PASSWD"  --encryption-method TLS --subject "$SUBJECTPREFIX ($DATESTR)" "$FROM" "$TO"  "$CONTENTPREFIX ($DATESTR)"
    done
fi
