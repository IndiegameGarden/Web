<?php
$target_dir = "game-uploads/"; // where new zip files go
$game_dir   = "game-store/"; // where unzipped files are hosted

$target_file = $target_dir . basename($_FILES["fileToUpload"]["name"]);
$uploadOk = 1;
$imageFileType = pathinfo($target_file,PATHINFO_EXTENSION);
$id = pathinfo($target_file,PATHINFO_FILENAME);
$game_dir = $game_dir . $id ;
echo "Uploading id=$id <br>" ;

// Check file size
if ($_FILES["fileToUpload"]["size"] > 8000000) {
    echo "Sorry, your file is too large.<br>";
    $uploadOk = 0;
}
// Allow certain file formats
if($imageFileType != "zip" && $imageFileType != "ZIP" ) {
    echo "Sorry, wrong file formatz.<br>";
    $uploadOk = 0;
}
// Check if $uploadOk is set to 0 by an error
if ($uploadOk == 0) {
    echo "Result -> Your file was not uploaded.<br>";
} else {
// if everything is ok, try to upload file
    if (move_uploaded_file($_FILES["fileToUpload"]["tmp_name"], $target_file)) {
        echo basename( $_FILES["fileToUpload"]["name"]). " has been uploaded.<br>";
        // unzip
        $file = $target_file;
        if (! is_dir( $game_dir ) ) {
          echo "Creating folder $game_dir <br>" ;
          mkdir($game_dir);
        }
        $zip = new ZipArchive;
        $res = $zip->open($file);
        if ($res === TRUE) {
          // extract it to the path we determined above
          $zip->extractTo($game_dir);
          $zip->close();
          echo "File $file extracted to $game_dir<br>";
        } else {
          echo "Result -> Error, I couldn't open $file for unzipping.<br>";
        }
    } else {
        echo "Result -> there was an error uploading your file.<br>";
    }
}
?>
