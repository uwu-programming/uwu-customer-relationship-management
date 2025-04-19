<?php

#model class for CRUD fnuctions
class model{
    protected $connection;
    protected $table;

    public function __construct($dbname, $tablename){
        $this->connection = $dbname;
        $this->table = $tablename;
    }
    
    public function getAllRecords(){
        $query = "SELECT * FROM " . $this->table;
        $stmt = $this->connection->prepare($query);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    public function getRecord($id){
        $query = "SELECT * FROM " . $this->table. " WHERE id = :id";
        $stmt = $this->connection->prepare($query);
        $stmt->bindParam(":id", $id);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    public function deleteRecord($id){
        $query = "DELETE FROM " . $this->table. " WHERE id = :id";
        $stmt = $this->connection->prepare($query);
        $stmt->bindParam(":id", $id);
        return $stmt->execute();
    }

    public function countRecord(){
        $query = "SELECT COUNT(*) as total FROM " . $this->table;
        $stmt = $this->connection->prepare($query);
        $stmt->execute();
        $row = $stmt->fetch(PDO::FETCH_ASSOC);
        return $row['total'];
    }

    public function searchRecord($column, $keyword){
       
        // this for many conditions
        $condition = [];
        foreach($column as $field){
            $condition[] = $field." LIKE :keyword";
        }

        $query = "SELECT * FROM " . $this->table . " WHERE ". implode(" OR ",$condition);
        $stmt = $this->connection->prepare($query);
        $keyword = "%$keyword%";
        $stmt->bindParam(":keyword", $keyword);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
        
    }



}
?>