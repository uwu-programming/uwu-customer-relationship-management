-- custom delimiter for writing procedure
DELIMITER $$

-- check if a procedure with same name exists, if so, drop it
DROP PROCEDURE IF EXISTS procedure_create_schema_uwuCRM_ABB $$
-- create a procedure to create the database schema
CREATE PROCEDURE procedure_create_schema_uwuCRM_ABB()
BEGIN
    DECLARE EXIT HANDLER FOR 1007
        BEGIN

        END;
    
    CREATE DATABASE uwuCRM_ABB;

END$$

-- set the delimiter back to default
DELIMITER ;

CALL procedure_create_schema_uwuCRM_ABB();