<?php

// continue the session
session_start();

// specify return type
header("Content-Type: application/json");

// connect to database
require "database_connection.php";

switch($_SERVER["REQUEST_METHOD"]){
    case "POST":
        edit_lead($conn);
        break;
    
    default:
        break;
}

function edit_lead($conn){
    try {

    } catch (PDOException $error){
        
    }
}

?>