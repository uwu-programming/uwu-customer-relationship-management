<?php

// continue the session
session_start();

// specify return type
header("Content-Type: application/json");

// connect to database
require "database_connection.php";

switch($_SERVER["REQUEST_METHOD"]){
    case "POST":
        edit_user($conn);
        break;
    
    default:
        break;
}

function edit_user($conn){
    try {
        // if the request is valid (user has permission)
        $valid = true;

        $current_user_id = $_SESSION['user_id'];
        $current_user_role = $_SESSION['user_role'];

        // expected post_data: {user_id, update_attribute, update_value}
        $post_data = json_decode(file_get_contents("php://input"));
        if (!(array_key_exists("user_id", (array)$post_data) && array_key_exists("update_table", (array)$post_data) && array_key_exists("update_attribute", (array)$post_data) && array_key_exists("update_value", (array)$post_data))){
            $valid = false;
            echo json_encode(array("message" => "Invalid post request."));
            http_response_code(400);
        }
        

        if ($valid && array_key_exists("operation", (array)$post_data) && $post_data->operation == "DELETE"){
            $delete_query = "DELETE FROM crm_user WHERE user_id = $post_data->user_id";
            $delete_statement = $conn->prepare($delete_query);
            $delete_statement->execute();

            http_response_code(204);
            echo json_encode(array("message" => "Successful deleted individual"));
        }

        if ($valid && $post_data->update_table == "crm_user"){
            if (($post_data->update_attribute == "phone_number" || $post_data->update_attribute == "email_address") && $post_data->update_value != NULL){
                $check_duplicate_query = "SELECT * FROM individual WHERE $post_data->update_attribute = $post_data->update_value";
                $check_duplicate_statement = $conn->prepare($check_duplicate_query);
                $check_duplicate_statement->execute();

                $check_duplicate_result = array();
                while ($row = $check_duplicate_statement->fetch(PDO::FETCH_ASSOC)){
                    array_push($check_duplicate_result, $row);
                }

                if (!(count($check_duplicate_result) == 0)){
                    $valid = false;
                    if ($post_data->update_attribute == "phone_number"){
                        echo json_encode(array("message" => "There entered phone number is already taken by another individual, please try again."));
                    } else {
                        echo json_encode(array("message" => "There entered email address is already taken by another individual, please try again."));
                    }
                }
            }

            if ($valid) {
                if ($post_data->update_value != NULL){
                    $update_query = "UPDATE $post_data->update_table SET $post_data->update_attribute = $post_data->update_value WHERE user_id = $post_data->user_id";
                } else {
                    $update_query = "UPDATE $post_data->update_table SET $post_data->update_attribute = NULL WHERE user_id = $post_data->user_id";
                }
                $update_statement = $conn->prepare($update_query);
                $update_statement->execute();

                http_response_code(204);
                echo json_encode(array("message" => "Update successfull"));
            }
        }

    } catch (PDOException $error){
        echo json_encode(array("message" => $error->errorInfo));
    }
}

?>