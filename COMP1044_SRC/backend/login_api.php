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
        login_crm($conn);
        break;

    // prevent other request method
    default:
        break;
}

// verify user_id & password for login
function login_crm($conn){
    try {
        // "php://": access I/O streams
        // "php://input": get raw data from the request body
        $data = json_decode(file_get_contents("php://input"));
        $user_id = $data->user_id;
        $password = $data->password;

        $sql_query = "SELECT * FROM crm_user WHERE user_id = $user_id AND password_hash = '$password'";
        $statement = $conn->prepare($sql_query);
        $statement->execute();
    } catch (PDOException $error){

    }

    $result = $statement->fetch(PDO::FETCH_ASSOC);
    if ($result != NULL){
        // store the logged in user in $_SESSION
        $_SESSION["user"] = $result['user_id'];
        $current_user = $result['user_id'];
        echo json_encode(["message" => $_SESSION['user'] . "aaa"]);
    }
    else
        echo json_encode(["message" => "no, $result"]);
}

?>