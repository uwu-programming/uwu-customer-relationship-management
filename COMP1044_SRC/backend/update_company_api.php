<?php

// continue the session
session_start();

// specify return type
header("Content-Type: application/json");

// connect to database
require "database_connection.php";

switch($_SERVER["REQUEST_METHOD"]){
    case "POST":
        update_company($conn);
        break;
    
    default:
        break;
}

function update_company($conn){
    try {
        $current_user_id = $_SESSION['user_id'];
        $current_user_role = $_SESSION['user_role'];

        $post_data = json_decode(file_get_contents("php://input"));

        $sql_query = "UPDATE company SET $post_data->attribute = '$post_data->value' WHERE company_id = $post_data->company_id";
        $sql_statement = $conn->prepare($sql_query);
        $sql_statement->execute();

        http_response_code(204);
    } catch (PDOException $error){
        http_response_code(400);
    }
}

?>