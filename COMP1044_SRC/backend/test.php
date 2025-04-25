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
    $c = $conn->prepare("SELECT * FROM (SELECT * FROM individual LEFT JOIN company USING(company_id) LEFT JOIN lead_individual USING(individual_id)) t1 LEFT JOIN (SELECT * FROM crm_user) t2 ON t2.user_id = t1.lead_owner_user_id LEFT JOIN (SELECT user_id AS created_by, user_name AS created_by_name FROM crm_user) t3 USING(created_by)");
    $c->execute();
}catch (PDOException $error){

}
$result = array();
$result2 = array();

while ($row = $a->fetch(PDO::FETCH_ASSOC)){
    array_push($result, $row);
}
while ($row = $c->fetch(PDO::FETCH_ASSOC)){
    array_push($result2, $row);
}
echo "aaaa???";
echo json_encode($result);
echo "<br><br><br>";
echo json_encode($result2);

foreach ($result as $value){
    echo "<br>";
    echo $value['Field'];
}

echo explode(".", 'aaaa')[1];
echo "huh";

?>