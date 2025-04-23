<?php

// continue the session
session_start();

// specify return type
header("Content-Type: application/json");

// connect to database
require "database_connection.php";

switch($_SERVER["REQUEST_METHOD"]){
    case "POST":
        retrieve_individual($conn);
        break;
    
    default:
        retrieve_individual($conn);
        break;
}

function retrieve_individual($conn){
    try {
        $current_user_id = $_SESSION['user_id'];
        $current_user_role = $_SESSION['user_role'];

        // get the JSON post by the client
        $post_data = json_decode(file_get_contents("php://input"));
        
        // the SQL query to get all lead individual
        $sql_query = "SELECT * FROM individual LEFT JOIN company ON individual.company_id = company.company_id JOIN lead_individual ON individual.individual_id = lead_individual.individual_id";
        
        // check if user is an admin
        if ($current_user_role == 1){
            // get all users
            
        } else {
            // only get lead that is under this particular user
            $sql_query = $sql_query . " WHERE lead_individual.user_id = $current_user_id";
        }

        if ($post_data->sort == true) {
            $sql_query = $sql_query . " ORDER BY individual.$post_data->sort_attribute $post_data->sort_by";
        }

        $statement = $conn->prepare($sql_query);
        $statement->execute();
    } catch (PDOException $error){

    }

    $result = array();
    while ($row = $statement->fetch(PDO::FETCH_ASSOC)){
        array_push($result, $row);
    }
    echo json_encode($result);
}

?>