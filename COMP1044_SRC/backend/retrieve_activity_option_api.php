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
        // get the POST JSON (expected data: {data})
        $post_data = json_decode(file_get_contents("php://input"));

        $sql_query = "DESC activity";
        $sql_statement = $conn->prepare($sql_query);
        $sql_statement->execute();

        $result = array();
        while ($row = $sql_statement->fetch(PDO::FETCH_ASSOC)){
            array_push($result, $row);
        }

        if (array_key_exists("data", (array)$post_data)){
            // if the request is to get field
            if ($post_data->data == "option"){
                $field_string = "";
                $field_array = array();
                foreach ($result as $key => $value){
                    if ($result[$key]['Field'] == "activity_type"){
                        // get the type: enum(...)
                        $field_string = $result[$key]['Type'];
                        // filter the enum() since it is a string type
                        $field_string = substr($field_string, 6, -2);

                        // explode to filer the ' in string
                        $unfilter_field_array = explode("'", $field_string);

                        // filter out the "," in array
                        foreach ($unfilter_field_array as $key => $value){
                            if ($value != ","){
                                array_push($field_array, $value);
                            }
                        }

                        break;
                    }
                }

                // output the array of lead status option
                echo json_encode($field_array);
            }
        } else {
            // else, return everything
            echo json_encode($result);
        }

    } catch (PDOException $error){

    }

}
?>