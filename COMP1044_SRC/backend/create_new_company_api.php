<?php

// continue the session
session_start();

// specify return type
header("Content-Type: application/json");

// connect to database
require "database_connection.php";

switch($_SERVER["REQUEST_METHOD"]){
    case "POST":
        create_company($conn);
        break;
    
    default:
        break;
}

function create_company($conn){
    try {
        $current_user_id = $_SESSION['user_id'];
        $current_user_role = $_SESSION['user_role'];

        $post_data = json_decode(file_get_contents("php://input"));

        $sql_query = "INSERT INTO company (company_name, company_address, company_description) VALUES(";

        if (array_key_exists("type", (array)$post_data) && $post_data->type == "create"){
            $sql_query = $sql_query . "$post_data->company_name, $post_data->company_address, $post_data->company_description)";
            $sql_statement = $conn->prepare($sql_query);
            $sql_statement->execute();
            http_response_code(204);
        } else {
            http_response_code(400);
        }

    } catch (PDOException $error){
        http_response_code(400);
    }
}

?>