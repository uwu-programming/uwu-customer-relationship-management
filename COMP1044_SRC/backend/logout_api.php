<?php

// start a new session
session_start();

// specify return type
header("Content-Type: application/json");

// connect to database
require_once "database_connection.php";

// $_SERVER is an array that contains data such as headers, paths, script locations
// ["REQUEST_METHOD"]: get which request method was used to access the page (GET, POST, PUT)
// for reference: https://www.php.net/manual/en/reserved.variables.server.php
switch($_SERVER["REQUEST_METHOD"]){
    case "POST":
        logout($conn);
        break;

    // prevent other request method
    default:
        break;
}

// verify user_id & password for login
function logout($conn){
    $_SESSION['user_name'] = NULL;
    $_SESSION['user_id'] = NULL;
    $_SESSION['user_role'] = NULL;
}

?>