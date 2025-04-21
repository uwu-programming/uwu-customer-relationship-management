<?php

$dsn = "mysql";
$host = "localhost";
$user = "root";
$password = "root";
$dbname = "uwucrm_abb_db";

try {
    $conn = new PDO("$dsn:host=$host; dbname=$dbname", $user, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch(PDOException $exception) {
    die("Connection failed: " . $exception->getMessage());
}

?>