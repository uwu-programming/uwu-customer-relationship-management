<?php

// continue the session
session_start();

// specify return type
header("Content-Type: application/json");

// connect to database
require "database_connection.php";

switch($_SERVER["REQUEST_METHOD"]){
    case "POST":
        retreive_company_individual($conn);
        break;
    
    default:
        retreive_company_individual($conn);
        break;
}

function retreive_company_individual($conn){
    try {
        $current_user_id = $_SESSION['user_id'];
        $current_user_role = $_SESSION['user_role'];

        // get the JSON post by the client
        $post_data = json_decode(file_get_contents("php://input"));

        $sql_query = "SELECT * FROM individual LEFT JOIN company ON individual.company_id = company.company_id WHERE individual.company_id = $post_data->company_id AND individual.relationship = '$post_data->relationship'";

        $statement = $conn->prepare($sql_query);
        $statement->execute();
    } catch (PDOException $error){
        http_response_code(400);
    } catch (Throwable $error){
        http_response_code(400);
    }

    $result = array();
    while ($row = $statement->fetch(PDO::FETCH_ASSOC)){
        array_push($result, $row);
    }

    echo json_encode($result);
}

?>