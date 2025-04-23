<?php

session_start();

echo "username: " . $_SESSION["user_name"] . "<br>";
echo "user_id: " . $_SESSION["user_id"] . "<br>";
echo "user_role: " . $_SESSION["user_role"];

require "database_connection.php";
try{
    $a = $conn->prepare("DESC individual");
    $a->execute();
    $b = $conn->prepare("DESC company");
    $b->execute();
}catch (PDOException $error){

}
$result = array();
while ($row = $a->fetch(PDO::FETCH_ASSOC)){
    array_push($result, $row);
}
while ($row = $b->fetch(PDO::FETCH_ASSOC)){
    array_push($result, $row);
}
echo json_encode($result);

foreach ($result as $value){
    echo "<br>";
    echo $value['Field'];
}

echo explode(".", 'aaaa')[1];
echo "huh";

?>