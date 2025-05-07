<?php

// continue the session
session_start();

// specify return type
header("Content-Type: application/json");

// connect to database
require "database_connection.php";

switch($_SERVER["REQUEST_METHOD"]){
    case "POST":
        retrieve_current_user($conn);
        break;

    default:
        retrieve_current_user($conn);
        break;
}

function retrieve_current_user($conn){
    try {
        $current_user_id = $_SESSION['user_id'];
        echo json_encode(array("user_id" => $current_user_id));
    } catch (PDOException $error){

    }

}
?>