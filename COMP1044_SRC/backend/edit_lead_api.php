<?php

// continue the session
session_start();

// specify return type
header("Content-Type: application/json");

// connect to database
require "database_connection.php";

switch($_SERVER["REQUEST_METHOD"]){
    case "POST":
        edit_lead($conn);
        break;
    
    default:
        break;
}

function edit_lead($conn){
    try {
        // if the request is valid (user has permission)
        $valid = true;

        $current_user_id = $_SESSION['user_id'];
        $current_user_role = $_SESSION['user_role'];

        // expected post_data: {individual_id, update_attribute, update_value}
        $post_data = json_decode(file_get_contents("php://input"));
        if (!(array_key_exists("individual_id", (array)$post_data) && array_key_exists("update_table", (array)$post_data) && array_key_exists("update_attribute", (array)$post_data) && array_key_exists("update_value", (array)$post_data))){
            $valid = false;
            echo json_encode(array("message" => "Invalid post request."));
            http_response_code(400);
        }
        
        // check if the user is admin, or else check if the user has the right lead
        if ($current_user_role != 1 && $valid){
            $check_query = "SELECT * FROM lead_individual WHERE individual_id = $post_data->individual_id AND lead_owner_user_id = $current_user_id";
            $check_statement = $conn->prepare($check_query);
            $check_statement->execute();

            $check_result = array();
            while ($row = $check_statement->fetch(PDO::FETCH_ASSOC)){
                array_push($check_result, $row);
            }

            if (!(count($check_result) > 0)){
                $valid = false;
                echo json_encode(array("message" => "You don't have permission to edit this user."));
            }
        }

        if ($valid && array_key_exists("operation", (array)$post_data) && $post_data->operation == "DELETE"){
            $delete_query = "DELETE FROM individual WHERE individual_id = $post_data->individual_id";
            $delete_statement = $conn->prepare($delete_query);
            $delete_statement->execute();

            http_response_code(204);
            echo json_encode(array("message" => "Successful deleted individual"));
        }

        if ($valid && $post_data->update_table == "individual"){
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
                    $update_query = "UPDATE $post_data->update_table SET $post_data->update_attribute = $post_data->update_value WHERE individual_id = $post_data->individual_id";
                } else {
                    $update_query = "UPDATE $post_data->update_table SET $post_data->update_attribute = NULL WHERE individual_id = $post_data->individual_id";
                }
                $update_statement = $conn->prepare($update_query);
                $update_statement->execute();

                http_response_code(204);
                echo json_encode(array("message" => "Update successfull"));
            }
        } else if ($valid && $post_data->update_table == "lead_individual"){
            // insert into convrsion history
            // check if it is converted to customer:
            if ($post_data->update_value == "'Converted to customer'"){
                $convert_to = "'Customer'";
                $update_query = "UPDATE individual SET relationship = 'Customer' WHERE individual_id = $post_data->individual_id";
                $update_statement = $conn->prepare($update_query);
                $update_statement->execute();
            } else {
                $convert_to = $post_data->update_value;
                // update the lead status
                $update_query = "UPDATE $post_data->update_table SET $post_data->update_attribute = $post_data->update_value WHERE individual_id = $post_data->individual_id";
                $update_statement = $conn->prepare($update_query);
                $update_statement->execute();
            }

            // check if it is converted from customer
            if ($post_data->convert_from == "'Converted to customer'"){
                $convert_from = "'Customer'";
                $update_query = "UPDATE individual SET relationship = 'Lead' WHERE individual_id = $post_data->individual_id";
                $update_statement = $conn->prepare($update_query);
                $update_statement->execute();
            } else {
                $convert_from = $post_data->convert_from;
                // update the lead status
                $update_query = "UPDATE $post_data->update_table SET $post_data->update_attribute = $post_data->update_value WHERE individual_id = $post_data->individual_id";
                $update_statement = $conn->prepare($update_query);
                $update_statement->execute();
            }

            $insert_query = "INSERT INTO conversion_history (user_id, individual_id, convert_from, convert_to, convert_time, conversion_message) VALUES ($current_user_id, $post_data->individual_id, $convert_from, $convert_to, NOW(), $post_data->conversion_message)";
            $insert_statement = $conn->prepare($insert_query);
            $insert_statement->execute();

            http_response_code(204);
            echo json_encode(array("message" => "Update successfull"));
        }

    } catch (PDOException $error){
        echo json_encode(array("message" => $error->errorInfo));
    }
}

?>