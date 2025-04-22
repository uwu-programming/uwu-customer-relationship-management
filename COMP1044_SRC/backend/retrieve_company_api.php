<?php


session_start();
header("Content-Type: application/json");

require "database_connection.php";

switch($_SERVER["REQUEST_METHOD"]){

    case "GET":
        if (isset($_GET["id"])) {
            retrieve_company($conn, $_GET["id"]);
        } else {
            retrieve_all_company($conn);
        }
        break;

    case "POST":
        create_company($conn);
        break;

    case "PUT":
        update_company($conn);
        break;

    case "DELETE":
        delete_company($conn);
        break;

    default:
        retrieve_all_company($conn);
        break;

}

function retrieve_all_company($conn) {

    try{
        $sql_query = "SELECT * FROM company";

        $statement = $conn->prepare($sql_query);
        $statement->execute();
        $result = $statement->fetchAll(PDO::FETCH_ASSOC);

        echo json_encode($result);

    }catch (PDOException $error){}
       
}

function retrieve_company($conn, $id) {

    try{
      
        $sql_query = "SELECT * FROM company WHERE company_id = :id";

        $statement = $conn->prepare($sql_query);
        $statement->bindParam(':id', $id);
        $statement->execute();

        $company = $statement->fetch(PDO::FETCH_ASSOC);

        if(!$company){
            http_response_code(404);
            echo json_encode(["error" => "Company does not exist."]);
            return;
        }

        //retreive all associated individuals of a specific company
        $sql_query = "SELECT * FROM individual WHERE company_id = :id";

        $statement = $conn->prepare($sql_query);
        $statement->bindParam(':id', $id);
        $statement->execute();

        $individuals = $statement->fetchAll(PDO::FETCH_ASSOC);

        $result= [
            "company" => $company,
            "individuals" => $individuals
        ];

        echo json_encode($result);

    } catch (PDOException $error){}
}

function create_company($conn) {

    try{
        $data = json_decode(file_get_contents("php://input"));
        
        //this make sure user filled in every field (not NULL)
        if(!isset($data->company_name)||!isset($data->company_address)) {
            http_response_code(400);
            echo json_encode(["error" => "Missing fields. Please fil in."]);
            return;
        }

        $sql_query = "INSERT INTO company (company_name, company_address) VALUES (:name, :address)";
        
        $statement = $conn->prepare($sql_query);
        $statement->bindParam(':name', $data->company_name);
        $statement->bindParam(':address', $data->company_address);

        $statement->execute();

        $company_id = $conn->lastInsertId();
        
    } catch (PDOException $error){}

}

function update_company($conn) {
    try {
        $data = json_decode(file_get_contents("php://input"));

        $update_fields = [];
        $params = [":id" => $data->company_id];

        if(isset($data->company_name)){
            $update_fields[] = "company_name = :name";
            $params[":name"] = $data->company_name;
        }

        if(isset($data->company_address)){
            $update_fields[] = "company_address = :address";
            $params[":address"] = $data->company_address;
        }

        $sql_query = "UPDATE company SET ".implode(", ", $update_fields) . " WHERE company_id = :id";
        $statement = $conn->prepare($sql_query);
        
        foreach ($params as $key => $value) {
            $statement->bindValue($key, $value);
        }

        $statement->execute();

        if ($statement->rowCount() === 0) {
            http_response_code(404);
            echo json_encode(["error" => "Company does not exist."]);
            return;
        }

        echo json_encode(["message" => "Company updated successfully."]);
    } catch (PDOException $error){}
}

function delete_company($conn) {

    try{
        $data = json_decode(file_get_contents("php://input"));
        
        if(!isset($data->company_id)) {
            http_response_code(400);
            echo json_encode(["error" => "Missing company."]);
            return;
        }

        //remove all individuals from the company
        $sql_query = "UPDATE individual SET company_id = NULL WHERE company_id = :id";
        
        $statement = $conn->prepare($sql_query);
        $statement->bindParam(':id', $data->company_id);
        $statement->execute();

        $sql_query = "DELETE FROM company WHERE company_id = :id";

        $statement = $conn->prepare($sql_query);
        $statement->bindParam(':id', $data->company_id);
        $statement->execute();

        if ($statement->rowCount() === 0) {
            http_response_code(404);
            echo json_encode(["error" => "Company does not exist."]);
            return;
        }

        echo json_encode(["message" => "Company deleted successfully."]);
    } catch (PDOException $error) {}
}
?> 