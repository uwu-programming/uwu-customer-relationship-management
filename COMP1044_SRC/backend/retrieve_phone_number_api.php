<?php

// continue the session
session_start();

// specify return type
header("Content-Type: application/json");

// connect to database
require "database_connection.php";

switch($_SERVER["REQUEST_METHOD"]){
    case "POST":
        retrieve_phone_number($conn);
        break;

    default:
        retrieve_phone_number($conn);
        break;
}

function retrieve_phone_number($conn){
    try {
        $post_data = json_decode(file_get_contents("php://input"));

        if (array_key_exists("phone_number", (array)$post_data)){
            $sql_query = "SELECT * FROM individual WHERE phone_number = $post_data->phone_number";
            $sql_statement = $conn->prepare($sql_query);
            $sql_statement->execute();

            $result = array();
            while ($row = $sql_statement->fetch(PDO::FETCH_ASSOC)){
                array_push($result, $row);
            }

            if (count($result) == 0){
                http_response_code(204);
                echo json_encode(array("message" => "no duplicate"));
            }

        } else {
            http_response_code(400);
        }

    } catch (PDOException $error){

    }
}

?>