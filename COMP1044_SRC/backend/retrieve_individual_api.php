<?php

// continue the session
session_start();

// specify return type
header("Content-Type: application/json");

// connect to database
require "database_connection.php";

switch($_SERVER["REQUEST_METHOD"]){
    case "POST":
        retrieve_individual($conn);
        break;
    
    default:
        retrieve_individual($conn);
        break;
}

function retrieve_individual($conn){
    try {
        $sql_query = "SELECT * FROM individual";
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