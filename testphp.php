<?php
require_once "config/database.php";

$database = new Database();
$conn = $database->get_connection();

if ($conn) {
    echo "Connected";
} else {
    echo "Cannot connect";
}
?>
