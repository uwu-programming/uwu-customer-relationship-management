<?php

// continue the session
session_start();

// specify return type
header("Content-Type: application/json");

// connect to database
require "database_connection.php";

switch($_SERVER["REQUEST_METHOD"]){
    case "POST":
        retrieve_conversion_history($conn);
        break;

    default:
        retrieve_conversion_history($conn);
        break;
}

function retrieve_conversion_history($conn){
    try {
        // get the POST JSON (expected data: {data})
        $post_data = json_decode(file_get_contents("php://input"));


        // check get type
        if (array_key_exists("individual_id", (array)$post_data)){
            $sql_query = "SELECT * FROM conversion_history JOIN crm_user ON conversion_history.user_id = crm_user.user_id WHERE individual_id = $post_data->individual_id ORDER BY conversion_history.convert_time DESC";
            $sql_statement = $conn->prepare($sql_query);
            $sql_statement->execute();

            $result = array();
            while ($row = $sql_statement->fetch(PDO::FETCH_ASSOC)){
                array_push($result, $row);
            }

            echo json_encode($result);
        } else {
            http_response_code(400);
            echo json_encode(array("message" => 'Bad request'));
        }
    } catch (PDOException $error){

    }

}
?>