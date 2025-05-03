<?php

// continue the session
session_start();

// specify return type
header("Content-Type: application/json");

// connect to database
require "database_connection.php";

switch($_SERVER["REQUEST_METHOD"]){
    case "POST":
        create_individual($conn);
        break;
    
    default:
        break;
}

function create_individual($conn){
    try {
        $current_user_id = $_SESSION['user_id'];
        $current_user_role = $_SESSION['user_role'];

        $post_data = json_decode(file_get_contents("php://input"));
        $requirement_JSON = json_decode($post_data->requirement);

        $sql_query = "INSERT INTO individual (";
            
        foreach ($requirement_JSON as $value){
            $requirement_array = explode(":", $value);

            $sql_query = $sql_query . $requirement_array[0];

            if ($value != end($requirement_JSON)){
                $sql_query = $sql_query . ",";
            } else {
                $sql_query = $sql_query . ", registered_date, created_by) VALUES(";
            }
        }

        foreach ($requirement_JSON as $value){
            $requirement_array = explode(":", $value);

            $sql_query = $sql_query . $requirement_array[1];

            if ($value != end($requirement_JSON)){
                $sql_query = $sql_query . ",";
            } else {
                $sql_query = $sql_query . ", NOW(), $current_user_id)";
            }
        }

        $sql_statement = $conn->prepare($sql_query);
        $sql_statement->execute();

        if (array_key_exists("relationship", (array)$post_data) && $post_data->relationship == 'Lead'){
            $sql_lead_query = "INSERT INTO lead_individual (individual_id, lead_owner_user_id) VALUES (";

            $insert_individual_id = "";
            $insert_lead_owner_user_id = $post_data->lead_owner_user_id;

            // get latest individual_id
            $count_statement = $conn->prepare("SELECT COUNT(*) AS quantity FROM individual");
            $count_statement->execute();

            $count_array = array();
            while ($row = $count_statement->fetch(PDO::FETCH_ASSOC)){
                array_push($count_array, $row);
            }

            $insert_individual_id = $count_array[0]['quantity'];

            $sql_lead_query = $sql_lead_query . "$insert_individual_id, $insert_lead_owner_user_id)";
            $sql_lead_statement = $conn->prepare($sql_lead_query);
            $sql_lead_statement->execute();            
        }

        http_response_code(204);
        echo json_encode(array("message" => "created new individual successfully"));
    } catch (PDOException $error){
        http_response_code(400);
    }
}

?>