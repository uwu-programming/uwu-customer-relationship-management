<?php

// continue the session
session_start();

// specify return type
header("Content-Type: application/json");

// connect to database
require "database_connection.php";

switch($_SERVER["REQUEST_METHOD"]){
    case "POST":
        create_user($conn);
        break;
    
    default:
        break;
}

function create_user($conn){
    try {
        $post_data = json_decode(file_get_contents("php://input"));

        $crm_user_query = "INSERT INTO crm_user(user_name, role_id) VALUES('$post_data->user_name', $post_data->role_id)";
        $crm_user_statement = $conn->prepare($crm_user_query);
        $crm_user_statement->execute();

        // get the newly created user id
        $get_user_id_query = "SELECT MAX(user_id) AS max_id FROM crm_user";
        $get_user_id_statement = $conn->prepare($get_user_id_query);
        $get_user_id_statement->execute();

        $count_array = array();
        while ($row = $get_user_id_statement->fetch(PDO::FETCH_ASSOC)){
            array_push($count_array, $row);
        }

        $user_id = $count_array[0]['max_id'];

        $password_salt = bin2hex(random_bytes(10));
        $password_hash = hash("sha256", $post_data->password . $password_salt);
        $crm_user_login_info_query = "INSERT INTO crm_user_login_info VALUES($user_id, '$password_salt', '$password_hash')";
        $crm_user_login_info_statement = $conn->prepare($crm_user_login_info_query);
        $crm_user_login_info_statement->execute();

        echo json_encode(array("user_id" => $user_id));
    } catch (PDOException $error){
        http_response_code(400);
    }
}

?>