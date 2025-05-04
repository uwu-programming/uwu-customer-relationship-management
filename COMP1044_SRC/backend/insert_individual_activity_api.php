<?php

// continue the session
session_start();

// specify return type
header("Content-Type: application/json");

// connect to database
require "database_connection.php";

switch($_SERVER["REQUEST_METHOD"]){
    case "POST":
        insert_individual($conn);
        break;
    
    default:
        break;
}

function insert_individual($conn){
    try {
        $current_user_id = $_SESSION['user_id'];
        $current_user_role = $_SESSION['user_role'];

        $post_data = json_decode(file_get_contents("php://input"));

        $sql_query = "INSERT INTO individual_activity_history VALUES(";

        if (array_key_exists("type", (array)$post_data) && $post_data->type == "insert"){
            $sql_query = $sql_query . " $post_data->individual_id,";
            $sql_query = $sql_query . " $post_data->activity_id)";

            $sql_statement = $conn->prepare($sql_query);
            $sql_statement->execute();

            echo json_encode(array("message" => "successfully add activity into individual history"));
            http_response_code(204);
        } else if (array_key_exists("type", (array)$post_data) && $post_data->type == "remove") {
            $sql_query = "DELETE FROM individual_activity_history WHERE activity_id = $post_data->activity_id AND individual_id = $post_data->individual_id";
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