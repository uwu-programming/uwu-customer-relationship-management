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

        $sql_query = "SELECT * FROM crm_user JOIN crm_user_login_info ON crm_user.user_id = crm_user_login_info.user_id WHERE crm_user.user_id = $user_id";
        $statement = $conn->prepare($sql_query);
        $statement->execute();
    } catch (PDOException $error){

    }

    $result = $statement->fetch(PDO::FETCH_ASSOC);
    if ($result != NULL){
        if (hash("sha256", ($password . $result['password_salt'])) == $result['password_hash']){
            // store the logged in user in $_SESSION
            $_SESSION['user_name'] = $result['user_name'];
            $_SESSION['user_id'] = $result['user_id'];
            $_SESSION['user_role'] = $result['role_id'];
            http_response_code(204);
        } else {

        }
    } else {

    }
}

?>