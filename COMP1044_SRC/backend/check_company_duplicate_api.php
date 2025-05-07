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
        check_duplicate($conn);
        break;

    // prevent other request method
    default:
        break;
}

// verify user_id & password for login
function check_duplicate($conn){
    try {
        $post_data = json_decode(file_get_contents("php://input"));

        $sql_query = "SELECT * FROM company WHERE company_name = $post_data->company_name AND company_address = $post_data->company_address";
        $statement = $conn->prepare($sql_query);
        $statement->execute();
    } catch (PDOException $error){

    }

    $result = $statement->fetch(PDO::FETCH_ASSOC);
    if ($result == NULL){
        http_response_code(204);
    } else {
        http_response_code(205);
    }
}

?>