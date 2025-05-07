<?php

// continue the session
session_start();

// specify return type
header("Content-Type: application/json");

// connect to database
require "database_connection.php";

switch($_SERVER["REQUEST_METHOD"]){
    case "POST":
        retrieve_user($conn);
        break;
    
    default:
    retrieve_user($conn);
        break;
}

function retrieve_user($conn){
    try {
        $current_user_id = $_SESSION['user_id'];
        $current_user_role = $_SESSION['user_role'];

        // get FIELD of crm_user and user_role TABLE
        $desc_crm_user_statement = $conn->prepare("DESC crm_user");
        $desc_crm_user_statement->execute();

        $desc_user_role_statement = $conn->prepare("DESC user_role");
        $desc_user_role_statement->execute();

        // store the FIELD value inside the array
        $desc_array = array();

        while ($row = $desc_crm_user_statement->fetch(PDO::FETCH_ASSOC)){
            array_push($desc_array, $row);
        }
        while ($row = $desc_user_role_statement->fetch(PDO::FETCH_ASSOC)){
            array_push($desc_array, $row);
        }

        // get the JSON post by the client
        $post_data = json_decode(file_get_contents("php://input"));

        $sql_query = "SELECT user_id, user_name, crm_user.role_id, role_name, role_description, COUNT(individual_id) AS total_leads FROM crm_user JOIN user_role ON crm_user.role_id = user_role.role_id LEFT JOIN lead_individual ON crm_user.user_id = lead_individual.lead_owner_user_id";

        // check if user is an admin
        if ($current_user_role == 1){
            $sql_query = $sql_query . " WHERE crm_user.role_id > 1";

            if (array_key_exists("requirement", (array)$post_data)){
                // decode the requirement (a JSON like string)
                $requirement_JSON = json_decode($post_data->requirement);
                
                if (count((array)$requirement_JSON) > 0){
                    $sql_query = $sql_query . " AND (";

                    // loop through the requirement array
                    foreach ($requirement_JSON as $value){
                        // seperate the requirement to TABLE and VALUE
                        $requirement_array = explode(":", $value);

                        // check if it is a hard requirement (using = instead of LIKE)
                        if (array_key_exists("hard_requirement", (array)$post_data)){
                            $sql_query = $sql_query . " $requirement_array[0] = $requirement_array[1]";
                        }
                        else {
                            if ($requirement_array[0] == 'role_id'){
                                $sql_query = $sql_query . " crm_user.role_id LIKE '%$requirement_array[1]%'";
                            } else {
                                $sql_query = $sql_query . " $requirement_array[0] LIKE '%$requirement_array[1]%'";
                            }
                        }

                        // add filter (AND / OR) if it is not the last requirement
                        if ($value != end($requirement_JSON))
                            if (array_key_exists("search_type", (array)$post_data) && $post_data->search_type == "SPECIFIC")
                                $sql_query = $sql_query . " AND";
                            else
                                $sql_query = $sql_query . " OR";
                    }

                    $sql_query = $sql_query . ")";
                }
            }
        } else if ($current_user_role == 2){
            $sql_query = $sql_query . " WHERE crm_user.role_id > 2";

            if (array_key_exists("requirement", (array)$post_data)){
                // decode the requirement (a JSON like string)
                $requirement_JSON = json_decode($post_data->requirement);
                
                if (count((array)$requirement_JSON) > 0){
                    $sql_query = $sql_query . " AND (";

                    // loop through the requirement array
                    foreach ($requirement_JSON as $value){
                        // seperate the requirement to TABLE and VALUE
                        $requirement_array = explode(":", $value);

                        // check if it is a hard requirement (using = instead of LIKE)
                        if (array_key_exists("hard_requirement", (array)$post_data)){
                            $sql_query = $sql_query . " $requirement_array[0] = $requirement_array[1]";
                        }
                        else {
                            if ($requirement_array[0] == 'role_id'){
                                $sql_query = $sql_query . " crm_user.role_id LIKE '%$requirement_array[1]%'";
                            } else {
                                $sql_query = $sql_query . " $requirement_array[0] LIKE '%$requirement_array[1]%'";
                            }
                        }

                        // add filter (AND / OR) if it is not the last requirement
                        if ($value != end($requirement_JSON))
                            if (array_key_exists("search_type", (array)$post_data) && $post_data->search_type == "GENERAL")
                                $sql_query = $sql_query . " OR";
                            else
                                $sql_query = $sql_query . " $post_data->filter";
                    }

                    $sql_query = $sql_query . ")";
                }
            }
        } else {
            $sql_query = $sql_query . " WHERE crm_user.role_id > $current_user_role";

            if (array_key_exists("requirement", (array)$post_data)){
                // decode the requirement (a JSON like string)
                $requirement_JSON = json_decode($post_data->requirement);
                
                if (count((array)$requirement_JSON) > 0){
                    $sql_query = $sql_query . " AND (";

                    // loop through the requirement array
                    foreach ($requirement_JSON as $value){
                        // seperate the requirement to TABLE and VALUE
                        $requirement_array = explode(":", $value);

                        // check if it is a hard requirement (using = instead of LIKE)
                        if (array_key_exists("hard_requirement", (array)$post_data)){
                            $sql_query = $sql_query . " $requirement_array[0] = $requirement_array[1]";
                        }
                        else {
                            if ($requirement_array[0] == 'role_id'){
                                $sql_query = $sql_query . " crm_user.role_id LIKE '%$requirement_array[1]%'";
                            } else {
                                $sql_query = $sql_query . " $requirement_array[0] LIKE '%$requirement_array[1]%'";
                            }
                        }

                        // add filter (AND / OR) if it is not the last requirement
                        if ($value != end($requirement_JSON))
                            if (array_key_exists("search_type", (array)$post_data) && $post_data->search_type == "GENERAL")
                                $sql_query = $sql_query . " OR";
                            else
                                $sql_query = $sql_query . " $post_data->filter";
                    }

                    $sql_query = $sql_query . ")";
                }
            }
        }

        $sql_query = $sql_query . " GROUP BY user_id";

        if (array_key_exists("lead_total_search", (array)$post_data) && $post_data->lead_total_search){
            $sql_query = $sql_query . " HAVING total_leads LIKE '%$post_data->lead_total_search_value%' OR total_leads $post_data->lead_total_search_value";
        }

        // check if the request asked to sort data
        // array_key_exists(mixed $key, array $array): check if key exists in array
        // (array): type conversion, converting $post_data (a mixed type) to associative array
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

            if ($post_data->sort_attribute == "total_leads"){
                $sql_query = $sql_query . " ORDER BY total_leads";
                if ($post_data->sort_by == "DESC"){
                    $sql_query = $sql_query . " $post_data->sort_by";
                }
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