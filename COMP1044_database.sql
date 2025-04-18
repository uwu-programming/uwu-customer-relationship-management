-- drop the old database schema (if exists) and replace it with a new one
DROP DATABASE IF EXISTS uwucrm_abb_db;
CREATE DATABASE uwucrm_abb_db;

-- select the database
USE uwucrm_abb_db;

-- role: used to identify different position of user
CREATE TABLE user_role(
    role_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    role_name VARCHAR(255) NOT NULL
);

-- user: the person who can log in and access the CRM system
CREATE TABLE user(
    user_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    user_name VARCHAR(255) NOT NULL,
    password_salt VARCHAR(10) NOT NULL,
    password_hash CHAR(64) NOT NULL,
    role_id INT NOT NULL,                               -- reference to the TABLE role

    FOREIGN KEY (role_id) REFERENCES user_role(role_id)
);

-- individual: includes all people outside from CRM users (contact, lead, customer)
CREATE TABLE individual(
    individual_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    first_name VARCHAR(255) DEFAULT NULL,
    middle_name VARCHAR(255) DEFAULT NULL,
    last_name VARCHAR(255) NOT NULL,
    gender ENUM("Male", "Female") NOT NULL,
    honorifics ENUM("Mr.", "Ms.", "Mrs.", "Dr.", "Prof.") NOT NULL,
    relationship ENUM("Contact", "Lead", "Customer") NOT NULL DEFAULT "Contact",
    country_code VARCHAR(10) DEFAULT NULL,                  -- reference to the TABLE country
    company_id INT DEFAULT NULL,                            -- reference to the TABLE company
    individual_description TEXT DEFAULT NULL,
    registered_date DATETIME NOT NULL
);

-- phone: the phone numbers of individual
CREATE TABLE phone(
    phone_number VARCHAR(20) UNIQUE NOT NULL,                           -- prevent duplicate phone numbers
    type_of_phone ENUM("Personal", "Company") NOT NULL,
    individual_id INT NOT NULL,

    FOREIGN KEY (individual_id) REFERENCES individual(individual_id) ON UPDATE CASCADE ON DELETE CASCADE
);

-- email: the email addresses of individual
CREATE TABLE email(
    email_address VARCHAR(255) UNIQUE NOT NULL,                         -- prevent duplicate email address
    type_of_email ENUM("Personal", "Company") NOT NULL,
    individual_id INT NOT NULL,

    FOREIGN KEY (individual_id) REFERENCES individual(individual_id) ON UPDATE CASCADE ON DELETE CASCADE
);

-- country: store the country code with respect to country name
CREATE TABLE country(
    country_code VARCHAR(10) PRIMARY KEY NOT NULL,
    country_name VARCHAR(64) NOT NULL
);
-- make attribute `country_code` from table `individual` refer to the `country_code` in table `country`
ALTER TABLE individual ADD CONSTRAINT FOREIGN KEY (country_code) REFERENCES country(country_code) ON UPDATE SET NULL ON DELETE SET NULL;

-- company: record the company
CREATE TABLE company(
    company_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    company_name VARCHAR(255) NOT NULL,
    company_address VARCHAR(255) NOT NULL
);
-- make attribute `company_id` from table `individual` refer to the `company_id` in the table `company`
ALTER TABLE individual ADD CONSTRAINT FOREIGN KEY (company_id) REFERENCES company(company_id) ON UPDATE SET NULL ON DELETE SET NULL;

-- lead_individual: record which individual is lead and their status
CREATE TABLE lead_individual(
    individual_id INT UNIQUE NOT NULL,
    lead_status ENUM("New", "Attempted to contact", "Contacted", "Junk lead", "Lost lead") NOT NULL DEFAULT "New",

    FOREIGN KEY (individual_id) REFERENCES individual(individual_id) ON UPDATE CASCADE ON DELETE CASCADE
);