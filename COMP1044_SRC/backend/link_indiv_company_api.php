<?php


session_start();
header("Content-Type: application/json");
require "database_connection.php";


switch($_SERVER["REQUEST_METHOD"]){
    case "POST":
        link_individual_company($conn);
        break;
    case "DELETE":
        unlink_individual_company($conn);
        break;
    default:
    link_individual_company($conn);
    break;
}

function link_individual_company($conn) {

    try{
        $data = json_decode(file_get_contents("php://input"));

        
        $sql_query = "SELECT * FROM individual WHERE individual_id = :individual_id";
        $statement = $conn->prepare($sql_query);
        $statement->bindParam(':individual_id', $data->individual_id);
        $statement->execute();
        
        //error handlign for non-existent individual and company
        if(!$statement->fetch()){
            http_response_code(404);
            echo json_encode(["error" => "Individual not found."]);
            return;
        }

        $sql_query = "SELECT * FROM company WHERE company_id = :company_id";
        $statement = $conn->prepare($sql_query);
        $statement->bindParam(':company_id', $data->company_id);
        $statement->execute();
        
        if(!$statement->fetch()){
            http_response_code(404);
            echo json_encode(["error" => "Company not found."]);
            return;
        }

        $sql_query = "UPDATE individual SET company_id = :company_id WHERE individual_id = :individual_id";
        
        $statement = $conn->prepare($sql_query);
        $statement->bindParam(':company_id', $data->company_id);
        $statement->bindParam(':individual_id', $data->individual_id);
        $statement->execute();

        echo json_encode(["message" => "Link successful."]);
    } catch (PDOException $error) {}
}

function unlink_individual_company($conn) {

    try{
        $data = json_decode(file_get_contents("php://input"));

      
        $sql_query = "UPDATE individual SET company_id = NULL WHERE individual_id = :individual_id";
        
        $statement = $conn->prepare($sql_query);
        $statement->bindParam(':individual_id', $data->individual_id);
        $statement->execute();

        if($statement->rowCount() == 0){
            http_response_code(404);
            echo json_encode(["error" => "Individual not found"]);
            return;
        }

        echo json_encode(["message" => "Unlink successful."]);
    } catch (PDOException $error) {}
}

?> 