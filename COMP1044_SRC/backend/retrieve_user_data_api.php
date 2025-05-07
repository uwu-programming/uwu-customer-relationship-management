<?php

// continue the session
session_start();

// specify return type
header("Content-Type: application/json");

// connect to database
require "database_connection.php";

switch($_SERVER["REQUEST_METHOD"]){
    case "POST":
        retrieve_user_data($conn);
        break;
    
    default:
        retrieve_user_data($conn);
        break;
}

function retrieve_user_data($conn){
    try {
        $current_user_id = $_SESSION['user_id'];
        $current_user_role = $_SESSION['user_role'];

        $post_data = json_decode(file_get_contents("php://input"));

        if (array_key_exists("type", (array)$post_data)){
            
            if ($post_data->type == "lead"){
                $sql_query = "SELECT * FROM individual LEFT JOIN lead_individual ON individual.individual_id = lead_individual.individual_id LEFT JOIN crm_user ON lead_individual.lead_owner_user_id = crm_user.user_id WHERE crm_user.user_id = $current_user_id";
            } else {
                $sql_query = "SELECT * FROM activity WHERE created_by = $current_user_id ORDER BY end_time DESC";
            }

            $statement = $conn->prepare($sql_query);
            $statement->execute();

            $result = array();
            while ($row = $statement->fetch(PDO::FETCH_ASSOC)){
                array_push($result, $row);
            }

            echo json_encode($result);
        } else {
            http_response_code(400);
        }

        
    } catch (PDOException $error){

    }
}

?>