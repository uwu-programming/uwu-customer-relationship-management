<?php

require_once __DIR__ . '/model.php';

class UserRoleModel extends model{
    public function __construct($pdo){
        parent::__construct($pdo, 'user_role');
    }
    public function create($role_name, $role_description = null) {
        $query = "INSERT INTO {$this->table} (role_name, role_description) 
                VALUES (:role_name, :role_description)";
        
        $stmt = $this->connection->prepare($query);

        $stmt->bindParam(':role_name', $role_name);
        if($role_description === null){
            $stmt->bindValue(':role_description', null, PDO::PARAM_NULL);
        }else{ 
            $stmt->bindParam(':role_description', $role_description);
        }

        return $stmt->execute();
    }
}

?>