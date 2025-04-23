<?php

session_start();

echo "username: " . $_SESSION["user_name"] . "<br>";
echo "user_id: " . $_SESSION["user_id"] . "<br>";
echo "user_role: " . $_SESSION["user_role"];

?>