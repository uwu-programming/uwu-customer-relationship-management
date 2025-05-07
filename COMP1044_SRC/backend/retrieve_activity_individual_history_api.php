<?php

// continue the session
session_start();

// specify return type
header("Content-Type: application/json");

// connect to database
require "database_connection.php";

switch($_SERVER["REQUEST_METHOD"]){
    case "POST":
        retrieve_individual_option($conn);
        break;
    
    default:
        retrieve_individual_option($conn);
        break;
}

function retrieve_individual_option($conn){
    try {
        $current_user_id = $_SESSION['user_id'];
        $current_user_role = $_SESSION['user_role'];

        // get the JSON post by the client
        $post_data = json_decode(file_get_contents("php://input"));

        // the SQL query to get all contact
        $sql_query = "SELECT * FROM individual_activity_history JOIN individual ON individual_activity_history.individual_id = individual.individual_id WHERE activity_id = $post_data->activity_id";

        // check if search
        if (array_key_exists("requirement", (array)$post_data)){
            // decode the requirement (a JSON like string)
            $requirement_JSON = json_decode($post_data->requirement);
            
            if (count((array)$requirement_JSON) > 0){
                // add AND (, since continue from where
                $sql_query = $sql_query . " AND (";

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
    } catch (PDOException $error){

    }

    $result = array();
    while ($row = $statement->fetch(PDO::FETCH_ASSOC)){
        array_push($result, $row);
    }

    echo json_encode($result);
}

?>