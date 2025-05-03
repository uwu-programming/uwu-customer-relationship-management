<?php

// continue the session
session_start();

// specify return type
header("Content-Type: application/json");

// connect to database
require "database_connection.php";

switch($_SERVER["REQUEST_METHOD"]){
    case "POST":
        create_activity($conn);
        break;
    
    default:
        break;
}

function create_activity($conn){
    try {
        $current_user_id = $_SESSION['user_id'];
        $current_user_role = $_SESSION['user_role'];

        $post_data = json_decode(file_get_contents("php://input"));

        $sql_query = "INSERT INTO activity (activity_type, start_time, end_time, activity_subject, activity_description) VALUES(";

        if (array_key_exists("type", (array)$post_data) && $post_data->type == "create"){
            $sql_query = $sql_query . " $post_data->activity_type,";
            $sql_query = $sql_query . " $post_data->start_time,";
            $sql_query = $sql_query . " $post_data->end_time,";
            $sql_query = $sql_query . " $post_data->activity_subject,";
            $sql_query = $sql_query . " $post_data->activity_description)";

            $sql_statement = $conn->prepare($sql_query);
            $sql_statement->execute();

            $get_activity_id_query = "SELECT COUNT(*) AS quantity FROM activity";
            $get_activity_id_statement = $conn->prepare($get_activity_id_query);
            $get_activity_id_statement->execute();

            $count_array = array();
            while ($row = $get_activity_id_statement->fetch(PDO::FETCH_ASSOC)){
                array_push($count_array, $row);
            }

            $activity_id = $count_array[0]['quantity'];

            echo json_encode(array("activity_id" => $activity_id));
        } else {
            http_response_code(400);
        }

    } catch (PDOException $error){
        http_response_code(400);
    }
}

?>