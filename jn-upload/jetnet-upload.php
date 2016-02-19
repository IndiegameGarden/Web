<?php
echo "jetnet-upload.php v1.0<br>\n" ;
$target_dir = "game-uploads/"; // where new zip files go
$game_dir   = "./"; // where unzipped files are hosted

$target_file = $target_dir . basename($_FILES["fileToUpload"]["name"]);
$uploadOk = 1;
$imageFileType = pathinfo($target_file,PATHINFO_EXTENSION);
$id = pathinfo($target_file,PATHINFO_FILENAME);
$game_dir = $game_dir . $id ;
echo "Uploading id=$id <br>\n" ;

// Check file size
if ($_FILES["fileToUpload"]["size"] > 18000000) {
    echo "Sorry, your file is too large.<br>\n";
    $uploadOk = 0;
}
// Allow certain file formats
if($imageFileType != "zip" && $imageFileType != "ZIP" ) {
    echo "Sorry, wrong file format uploaded.<br>\n";
    $uploadOk = 0;
}
// Check if $uploadOk is set to 0 by an error
if ($uploadOk == 0) {
    echo "Result -> Your file was not uploaded.<br>\n";
} else {
// if everything is ok, try to upload file
    if (move_uploaded_file($_FILES["fileToUpload"]["tmp_name"], $target_file)) {
        echo basename( $_FILES["fileToUpload"]["name"]). " has been uploaded.<br>\n";
        // unzip
        $file = $target_file;
        if (! is_dir( $game_dir ) ) {
          echo "Creating folder $game_dir <br>\n" ;
          mkdir($game_dir);
        }
        $zip = new ZipArchive;
        $res = $zip->open($file);
        if ($res === TRUE) {
          // extract it to the path we determined above
          $zip->extractTo($game_dir);
          $zip->close();
          echo "File $file extracted to $game_dir<br>\n";
		  unlink($file);
        } else {
          echo "Result -> Error, I couldn't open $file for unzipping.<br>\n";
        }
    } else {
        echo "Result -> there was an error uploading your file.<br>\n";
    }
}
?>
