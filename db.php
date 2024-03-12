<?php
function connectD(){
$dns = "mysql:host=localhost;dbname=fclogistic";
$user = "root";
$password = "";
try{
 $db = new PDO ($dns, $user, $password);
}catch( PDOException $e){
 $error = $e->getMessage();
 echo $error;
}
return $db;
}

function closeD($conn){
	$conn = null;
}
