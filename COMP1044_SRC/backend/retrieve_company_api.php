<?php

// continue the session
session_start();

// specify return type
header("Content-Type: application/json");

// connect to database
require "database_connection.php";

switch($_SERVER["REQUEST_METHOD"]){
    case "POST":
        retrieve_company($conn);
        break;

    default:
        retrieve_company($conn);
        break;
}

function retrieve_company($conn){
    try {
        // get the POST JSON (expected data: {data})
        $post_data = json_decode(file_get_contents("php://input"));

        $sql_query = "SELECT * FROM company";

        $desc_company_statement = $conn->prepare("DESC company");
        $desc_company_statement->execute();

        // store the FIELD value inside the array
        $desc_array = array();

        while ($row = $desc_company_statement->fetch(PDO::FETCH_ASSOC)){
            array_push($desc_array, $row);
        }

        if (array_key_exists("requirement", (array)$post_data)){
            // decode the requirement (a JSON like string)
            $requirement_JSON = json_decode($post_data->requirement);
            
            if (count((array)$requirement_JSON) > 0){
                $sql_query = $sql_query . " WHERE";

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
                    if ($value != end($requirement_JSON)){
                        if (array_key_exists("search_type", (array)$post_data) && $post_data->search_type == "GENERAL")
                            $sql_query = $sql_query . " OR";
                        else
                            $sql_query = $sql_query . " $post_data->filter";
                    }
                }
            }

            if (array_key_exists("sort", (array)$post_data) && $post_data->sort == true) {
                foreach ($desc_array as $data){
                    // str_contains(string $haystack, string $needle): check if $needle exists in $haystack
                    // since we may pass "Please select an option", we need to do verification first
                    // explode(string $seperator, string $string): seperate $string by $seperator
                    // since we pass the table alongside with field name, we need to explode the string first
                    if (!(str_contains($post_data->sort_attribute, " ")) && $data['Field'] == $post_data->sort_attribute){
                        $sql_query = $sql_query . " ORDER BY $post_data->sort_attribute";
                        if ($post_data->sort_by == "DESC"){
                            $sql_query = $sql_query . " $post_data->sort_by";
                        }
                        break;
                    }
                }
            }
        }

        // for filter
        if (array_key_exists("filter", (array)$post_data) && !(array_key_exists("requirement", (array)$post_data))){
            $sql_query = $sql_query . " WHERE company_name LIKE '%$post_data->filter%'";
        } else if (array_key_exists("company_id", (array)$post_data)){
            $sql_query = $sql_query . " WHERE company_id = $post_data->company_id";
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
            if ($post_data->data == "option"){
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