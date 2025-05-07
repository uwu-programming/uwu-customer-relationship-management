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
        check_login($conn);
        break;

    // prevent other request method
    default:
        check_login($conn);
        break;
}

// verify user_id & password for login
function check_login($conn){
    if (array_key_exists("user_id", $_SESSION)){
        if ($_SESSION['user_id'] == NULL){
            http_response_code(400);
        } else {
            http_response_code(204);
        }
    } else {
        http_response_code(400);
    }
}

?>