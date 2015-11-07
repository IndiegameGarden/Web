#!/bin/bash
#curl -A "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.101 Safari/537.36" http://jetnet.indiegamegarden.com/jn-upload.html
curl 'http://jetnet.indiegamegarden.com/jetnet-upload.php' \
  -A "Mozilla/5.0 (Windows NT 6.1)" \
  -F "fileToUpload=@Astray.zip"
