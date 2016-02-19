#!/bin/bash

cd ~
echo "Jet-Net Build Your Own Game - webgame uploader."

# get/generate the student's id for game
date=$(date +%Y%m%d)
if [ -f studentid ]
then
  studentid=$(cat studentid)
else
  studentid=$(cat /dev/urandom | tr -cd [:alnum:] | head -c 4)
  echo "$studentid" > studentid
fi
# set other variables
ID="$date$studentid"
GAMEURL="http://play.indiegamegarden.com/$ID"
fn="$ID.zip"
echo "File ID to be uploaded: $fn"

# put game html5 into a zip file
rm -f $fn
pushd ~/Desktop/Game/BreakIt/Export/html5/bin > /dev/null
zip -q -r ~/$fn *
popd > /dev/null

# upload zip to server
echo "Uploading file to web server... just a moment"
curl 'http://play.indiegamegarden.com/jetnet-upload.php' \
  -A "Mozilla/5.0 (Windows NT 6.1)" \
  -F "fileToUpload=@$fn"

if [ $? -eq 0 ]
then

    # gen qr code
    qrencode -s 6 -o ~/Desktop/QR.png $GAMEURL
    eog -g ~/Desktop/QR.png & >& /dev/null

    echo " "
    echo "------------------------------------------------"
    echo "Your game is now online on:"
    echo " $GAMEURL"
    echo "------------------------------------------------"
    echo " "
    #zenity --info --text="Your game can be played at:\n\n$GAMEURL"

fi
read -p "Press [ENTER] to close window"
