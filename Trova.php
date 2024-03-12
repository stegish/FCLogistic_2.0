<?php
require_once('db.php');
$query = 'SELECT * FROM magazzino';
$conn= connectD();
$stm = $conn->prepare($query);
$stm->execute();
$row = $stm->fetch();
closeD($conn);
echo json_encode($row);