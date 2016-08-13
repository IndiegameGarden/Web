#!/bin/bash

cd ~
echo " "
echo "==============================="
echo "Jet-Net iPhone game link script"
echo "==============================="
echo " "

# ask before proceeding
sg=$(cat /usr/share/jetnet/dev/sg.id | tr -cd 123456789 | head -c 4)
read -p "Enter the access code: " sgin
if [ "$sg" != "$sgin" ]
then
    echo "INCORRECT"
    exit;
fi

# get/generate the student's id for game
date=$(date +%Y%m%d)
if [ -f studentid ]
then
  studentid=$(cat studentid)
else
  studentid=$(cat /dev/urandom | tr -cd 23456789abcdefghjkmnpqrstuvwxyz | head -c 5)
  echo "$studentid" > studentid
  chmod u-w studentid
fi

# set other variables
GAMEURL="http://play.indiegamegarden.com/play.php?id=$date$studentid"
UPLOADURL="http://play.indiegamegarden.com/j3t-upload.php?id=$date$studentid"
TESTURL="http://play.indiegamegarden.com/j3t-active.php"
fn="game.zip"

# test server status
curl $TESTURL -f -A "Mozilla/5.0 (Windows NT 6.1)" >& /dev/null
if [ $? -ne 0 ]
then
    echo "Server not responding, try again later!"
    echo " "
    read -p "Press [ENTER] to close this window"
    exit
fi

# put game html5 into a zip file
echo "File for upload: $fn"
rm -f $fn
pushd ~/Desktop/Game/BreakIt/Export/html5/bin > /dev/null
zip -q -r ~/$fn *
popd > /dev/null

# upload zip to server
echo "Uploading file ... just a moment"
curl $UPLOADURL \
  -f -A "Mozilla/5.0 (Windows NT 6.1)" \
  -F "fileToUpload=@$fn"

if [ $? -eq 0 ]
then

    # gen qr code
    qrencode -s 6 -o ~/QR.png $GAMEURL
    eog -g ~/QR.png & >& /dev/null

    echo " "
    echo "----------------------------------------------------------------------"
    echo "Your mobile game link is:"
    echo " $GAMEURL"
    echo "----------------------------------------------------------------------"
    echo " "
    #zenity --info --text="blah:\n\n$GAMEURL"

fi
read -p "Press [ENTER] to close window"
