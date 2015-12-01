#!/bin/bash

# put game html5 into a zip file
zip -r ~/game.zip ~/Desktop/Game/BreakIt/Export/html5/bin/*

# upload zip to server
curl 'http://jetnet.indiegamegarden.com/jetnet-upload.php' \
  -A "Mozilla/5.0 (Windows NT 6.1)" \
  -F "fileToUpload=game.zip"
