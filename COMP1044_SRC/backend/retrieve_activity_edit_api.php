<?php

// continue the session
session_start();

// specify return type
header("Content-Type: application/json");

// connect to database
require "database_connection.php";

switch($_SERVER["REQUEST_METHOD"]){
    case "POST":
        retrieve_activity($conn);
        break;
    
    default:
        retrieve_activity($conn);
        break;
}

function retrieve_activity($conn){
    try {
        $current_user_id = $_SESSION['user_id'];
        $current_user_role = $_SESSION['user_role'];

        // get the JSON post by the client
        $post_data = json_decode(file_get_contents("php://input"));

        // the SQL query to get activity information
        $sql_query = "SELECT * FROM activity JOIN crm_user ON activity.created_by = crm_user.user_id WHERE activity_id = $post_data->activity_id";

        $statement = $conn->prepare($sql_query);
        $statement->execute();

        $result = array();
        while ($row = $statement->fetch(PDO::FETCH_ASSOC)){
            array_push($result, $row);
        }

        echo json_encode($result);
    } catch (PDOException $error){

    }
}

?>