#!/bin/bash

cd ~
echo "Jet-Net Bouw Je Eigen Game - game uploader."

# get/generate the student's id for game
date=$(date +%Y%m%d)
if [ -f studentid ]
then
  studentid=$(cat studentid)
else
  studentid=$(cat /dev/urandom | tr -cd [:alnum:] | head -c 4)
  echo "$studentid" > studentid
fi
ID="$date$studentid"
fn="$ID.zip"

# put game html5 into a zip file
rm -f $fn
pushd ~/Desktop/Game/BreakIt/Export/html5/bin
zip -r ~/$fn *
popd

# upload zip to server
echo "Uploading file to web server... just a moment"
curl 'http://play.indiegamegarden.com/jetnet-upload.php' \
  -A "Mozilla/5.0 (Windows NT 6.1)" \
  -F "fileToUpload=@$fn"

echo " "
echo "------------------------------------------------"
echo "Game is online on:"
echo "http://play.indiegamegarden.com/$ID"
echo "------------------------------------------------"
read -p "Press [ENTER] to exit."
