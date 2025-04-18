-- drop the old database schema (if exists) and replace it with a new one
DROP DATABASE IF EXISTS uwucrm_abb_db;
CREATE DATABASE uwucrm_abb_db;

-- select the database
USE uwucrm_abb_db;

-- role: used to identify different position of user
CREATE TABLE role(
    role_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    role_name VARCHAR(255) NOT NULL
);

-- password: the password of user in hash code, and salt
CREATE TABLE user_password(
    user_password_id INT PRIMARY KEY NOT NULL,
    password_salt VARCHAR(10) NOT NULL,
    password_hash CHAR(64) NOT NULL
);

-- user: the person who can log in and access the CRM system
CREATE TABLE user(
    user_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    user_name VARCHAR(255) UNIQUE NOT NULL,
    user_password_id INT NOT NULL,                      -- reference to the TABLE password
    role_id INT NOT NULL,                               -- reference to the TABLE role

    FOREIGN KEY (user_password_id) REFERENCES user_password(user_password_id),
    FOREIGN KEY (role_id) REFERENCES role(role_id)
);

