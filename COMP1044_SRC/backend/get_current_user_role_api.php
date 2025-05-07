<?php

// continue the session
session_start();

// specify return type
header("Content-Type: application/json");

// connect to database
require "database_connection.php";

switch($_SERVER["REQUEST_METHOD"]){
    case "POST":
        retrieve_current_user_role($conn);
        break;

    default:
        retrieve_current_user_role($conn);
        break;
}

function retrieve_current_user_role($conn){
    try {
        $current_user_role = $_SESSION['user_role'];
        echo json_encode(array("user_role" => $current_user_role));
    } catch (PDOException $error){

    }

}
?>