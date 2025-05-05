<?php

// continue the session
session_start();

// specify return type
header("Content-Type: application/json");

// connect to database
require "database_connection.php";

switch($_SERVER["REQUEST_METHOD"]){
    case "POST":
        retrieve_activity($conn);
        break;
    
    default:
        retrieve_activity($conn);
        break;
}

function retrieve_activity($conn){
    try {
        $current_user_id = $_SESSION['user_id'];
        $current_user_role = $_SESSION['user_role'];

        // get the JSON post by the client
        $post_data = json_decode(file_get_contents("php://input"));

        // the SQL query to get all contact
        $sql_query = "SELECT * FROM activity LEFT JOIN crm_user ON activity.created_by = crm_user.user_id";

        // get FIELD of activity and crm_user TABLE
        $desc_activity_statement = $conn->prepare("DESC activity");
        $desc_activity_statement->execute();

        $desc_crm_user_statement = $conn->prepare("DESC crm_user");
        $desc_crm_user_statement->execute();

        // store the FIELD value inside the array
        $desc_array = array();

        while ($row = $desc_activity_statement->fetch(PDO::FETCH_ASSOC)){
            array_push($desc_array, $row);
        }
        while ($row = $desc_crm_user_statement->fetch(PDO::FETCH_ASSOC)){
            array_push($desc_array, $row);
        }

        if ($current_user_role <= 2){
            // get all activity
            
        } else {
            // only get activity that is under this particular user
            $sql_query = $sql_query . " WHERE activity.created_by = $current_user_id";
        }

        // check if the request asked to filter data
        if (array_key_exists("requirement", (array)$post_data)){
            // decode the requirement (a JSON like string)
            $requirement_JSON = json_decode($post_data->requirement);

            if (count((array)$requirement_JSON) > 0){
                // add WHERE clause for admin
                if ($current_user_role <= 2)
                    $sql_query = $sql_query . " WHERE(";
                // add syntax for normal user (cause individual_id filter)
                else
                    $sql_query = $sql_query . " AND( ";
            }
            
            if (count((array)$requirement_JSON) > 0){
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
                        if (array_key_exists("search_type", (array)$post_data) && $post_data->search_type == "GENERAL")
                            $sql_query = $sql_query . " OR";
                        else
                            $sql_query = $sql_query . " $post_data->filter";
                }

                $sql_query = $sql_query . " ) ";
            }
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
    //echo($sql_query);
}

?>