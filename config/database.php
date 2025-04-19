<?php
// referenced https://www.w3schools.com/php/php_mysql_connect.asp
class Database {
    private $dbhost = "localhost";
    private $dbname = "uwucrm_abb_db;";  
    private $username = "root";      
    private $password = "root";      
    public $conn;

    public function get_connection(){
        $this->conn = null;

        try {
            $this->conn = new PDO(
                "mysql:host=" . $this->dbhost . ";dbname=" . $this->dbname,
                $this->username,
                $this->password
            );
            $this->conn->exec("set names utf8");
        } catch (PDOException $exception) {
            echo "Unable to connect: " . $exception->getMessage();
        }

        return $this->conn;
    }
}