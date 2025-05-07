<?php

// continue the session
session_start();

// specify return type
header("Content-Type: application/json");

// connect to database
require "database_connection.php";

switch($_SERVER["REQUEST_METHOD"]){
    case "POST":
        update_activity($conn);
        break;
    
    default:
        break;
}

function update_activity($conn){
    try {
        $current_user_id = $_SESSION['user_id'];
        $current_user_role = $_SESSION['user_role'];

        $post_data = json_decode(file_get_contents("php://input"));

        $sql_query = "UPDATE activity SET";

        if (array_key_exists("type", (array)$post_data) && $post_data->type == "update"){
            $sql_query = $sql_query . " $post_data->update_attribute = $post_data->update_value WHERE activity_id = $post_data->activity_id";
            $sql_statement = $conn->prepare($sql_query);
            $sql_statement->execute();

            http_response_code(204);
        } else if (array_key_exists("type", (array)$post_data) && $post_data->type == "update_time") {
            $sql_query = $sql_query . " start_time = $post_data->start_time, end_time = $post_data->end_time WHERE activity_id = $post_data->activity_id";
            $sql_statement = $conn->prepare($sql_query);
            $sql_statement->execute();

            http_response_code(204);
        } else if (array_key_exists("type", (array)$post_data) && $post_data->type == "delete") {
            $sql_query = "DELETE FROM activity WHERE activity_id = $post_data->activity_id";
            $sql_statement = $conn->prepare($sql_query);
            $sql_statement->execute();

            http_response_code(204);
        }else {
            http_response_code(400);
        }

    } catch (PDOException $error){
        http_response_code(400);
    }
}

?>