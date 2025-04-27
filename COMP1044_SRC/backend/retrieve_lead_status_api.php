<?php

// continue the session
session_start();

// specify return type
header("Content-Type: application/json");

// connect to database
require "database_connection.php";

switch($_SERVER["REQUEST_METHOD"]){
    case "POST":
        retrieve_lead_status($conn);
        break;

    default:
        retrieve_lead_status($conn);
        break;
}

function retrieve_lead_status($conn){
    try {
        $sql_query = "DESC lead_individual";
        $sql_statement = $conn->prepare($sql_query);
        $sql_statement->execute();

        // get the POST JSON (expected data: {data})
        $post_data = json_decode(file_get_contents("php://input"));

        $result = array();
        while ($row = $sql_statement->fetch(PDO::FETCH_ASSOC)){
            array_push($result, $row);
        }

        // check get type
        if (array_key_exists("data", (array)$post_data)){
            // if the request is to get field
            if (true || $post_data->data == "option"){
                $field_string = "";
                $field_array = array();
                foreach ($result as $key => $value){
                    if ($result[$key]['Field'] == "lead_status"){
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