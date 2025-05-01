<?php

// continue the session
session_start();

// specify return type
header("Content-Type: application/json");

// connect to database
require "database_connection.php";

switch($_SERVER["REQUEST_METHOD"]){
    case "POST":
        retrieve_user_role($conn);
        break;

    default:
        retrieve_user_role($conn);
        break;
}

function retrieve_user_role($conn){
    try {
        $current_role_id = $_SESSION['user_role'];

        // get the POST JSON (expected data: {data})
        $post_data = json_decode(file_get_contents("php://input"));

        $sql_query = "SELECT * FROM user_role";

        // for filter
        if (array_key_exists("filter", (array)$post_data)){
            $sql_query = $sql_query . " WHERE role_name LIKE '%$post_data->filter%' AND role_id > $current_role_id";
        } else {
            $sql_query = $sql_query . " WHERE role_id > $current_role_id";
        }

        $sql_statement = $conn->prepare($sql_query);
        $sql_statement->execute();

        $result = array();
        while ($row = $sql_statement->fetch(PDO::FETCH_ASSOC)){
            array_push($result, $row);
        }

        // check get type
        if (array_key_exists("data", (array)$post_data) && count($result) > 0){
            // if the request is to get field
            if (true || $post_data->data == "option"){
                echo json_encode($result);
            }
        } else {
            // else, return everything
            echo json_encode($result);
        }

    } catch (PDOException $error){

    }

}
?>