<?php

// continue the session
session_start();

// specify return type
header("Content-Type: application/json");

// connect to database
require "database_connection.php";

switch($_SERVER["REQUEST_METHOD"]){
    case "POST":
        update_owner($conn);
        break;
    
    default:
        break;
}

function update_owner($conn){
    try {
        $post_data = json_decode(file_get_contents("php://input"));

        $sql_query = "UPDATE lead_individual SET lead_owner_user_id = $post_data->user_id WHERE individual_id = $post_data->individual_id";
        $sql_statement = $conn->prepare($sql_query);
        $sql_statement->execute();

        http_response_code(204);
    } catch (PDOException $error){
        echo json_encode(array("message" => $error->errorInfo));
    }
}

?>