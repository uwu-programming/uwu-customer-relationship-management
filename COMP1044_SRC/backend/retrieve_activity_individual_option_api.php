<?php

// continue the session
session_start();

// specify return type
header("Content-Type: application/json");

// connect to database
require "database_connection.php";

switch($_SERVER["REQUEST_METHOD"]){
    case "POST":
        retrieve_activity_option($conn);
        break;
    
    default:
        retrieve_activity_option($conn);
        break;
}

function retrieve_activity_option($conn){
    try {
        $current_user_id = $_SESSION['user_id'];
        $current_user_role = $_SESSION['user_role'];

        // get the JSON post by the client
        $post_data = json_decode(file_get_contents("php://input"));

        // the SQL query to get all contact
        $sql_query = "SELECT * FROM individual";

        if ($current_user_role > 2){
            $sql_query = $sql_query . " WHERE (individual.relationship = 'Contact' OR individual.relationship = 'Customer')";
        }

        // check if the request asked to filter data
        if (array_key_exists("requirement", (array)$post_data)){
            // decode the requirement (a JSON like string)
            $requirement_JSON = json_decode($post_data->requirement);
            
            if (count((array)$requirement_JSON) > 0){
                // admin can access all the individual, therefore there is no WHERE before
                if ($current_user_role <= 2)
                    $sql_query = $sql_query . " WHERE(";
                else
                    $sql_query = $sql_query . " AND(";

                // loop through the requirement array
                foreach ($requirement_JSON as $value){
                    // seperate the requirement to TABLE and VALUE
                    $requirement_array = explode(":", $value);

                    // check if it is a hard requirement (using = instead of LIKE)
                    if (array_key_exists("hard_requirement", (array)$post_data))
                        $sql_query = $sql_query . " $requirement_array[0] = $requirement_array[1]";
                    else
                        $sql_query = $sql_query . " $requirement_array[0] LIKE '%$requirement_array[1]%'";

                    // add filter (AND / OR) if it is not the last requirement
                    if ($value != end($requirement_JSON))
                        $sql_query = $sql_query . " OR";
                }

                $sql_query = $sql_query . " ) ";
            }
        }

        $statement = $conn->prepare($sql_query);
        $statement->execute();

        // SPECIAL FOR non admin
        if ($current_user_role > 2){
            $additional_query = "SELECT * FROM lead_individual JOIN individual ON lead_individual.individual_id = individual.individual_id WHERE lead_individual.lead_owner_user_id = $current_user_id";
            
            // check if the request asked to filter data
        if (array_key_exists("requirement", (array)$post_data)){
            // decode the requirement (a JSON like string)
            $requirement_JSON = json_decode($post_data->requirement);
            
            if (count((array)$requirement_JSON) > 0){
                $additional_query = $additional_query . " AND(";

                // loop through the requirement array
                foreach ($requirement_JSON as $value){
                    // seperate the requirement to TABLE and VALUE
                    $requirement_array = explode(":", $value);

                    // check if it is a hard requirement (using = instead of LIKE)
                    if (array_key_exists("hard_requirement", (array)$post_data))
                        $additional_query = $additional_query . " $requirement_array[0] = $requirement_array[1]";
                    else
                        $additional_query = $additional_query . " $requirement_array[0] LIKE '%$requirement_array[1]%'";

                    // add filter (AND / OR) if it is not the last requirement
                    if ($value != end($requirement_JSON))
                        $additional_query = $additional_query . " OR";
                }

                $additional_query = $additional_query . " ) ";
            }
        }
            
            $additional_statement = $conn->prepare($additional_query);
            $additional_statement->execute();
        }

    } catch (PDOException $error){

    }

    $result = array();
    while ($row = $statement->fetch(PDO::FETCH_ASSOC)){
        array_push($result, $row);
    }

    // SPECIAL FOR non admin
    if ($current_user_role > 2){
        while ($row = $additional_statement->fetch(PDO::FETCH_ASSOC)){
            array_push($result, $row);
        }
    }

    echo json_encode($result);
}

?>