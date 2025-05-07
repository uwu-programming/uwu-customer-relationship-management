-- drop the old database schema (if exists) and replace it with a new one
DROP DATABASE IF EXISTS uwucrm_abb_db;
CREATE DATABASE uwucrm_abb_db;

-- select the database
USE uwucrm_abb_db;

-- role: used to identify different position of crm_user
CREATE TABLE user_role(
    role_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    role_name VARCHAR(255) NOT NULL,
    role_description TEXT DEFAULT NULL
);

-- crm_user: the person who can log in and access the CRM system
CREATE TABLE crm_user(
    user_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    user_name VARCHAR(255) NOT NULL,
    role_id INT NOT NULL,                               -- reference to the TABLE role

    FOREIGN KEY (role_id) REFERENCES user_role(role_id) ON UPDATE CASCADE ON DELETE CASCADE
);

-- crm_user_login_info: store the login info (password_salt and password_hash)
CREATE TABLE crm_user_login_info(
    user_id INT UNIQUE NOT NULL,
    password_salt CHAR(10) NOT NULL,
    password_hash VARCHAR(64) NOT NULL,

    FOREIGN KEY (user_id) REFERENCES crm_user(user_id) ON UPDATE CASCADE ON DELETE CASCADE
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
    phone_number VARCHAR(255) UNIQUE DEFAULT NULL,
    email_address VARCHAR(255) UNIQUE DEFAULT NULL,
    country_code VARCHAR(10) DEFAULT NULL,                  -- reference to the TABLE country
    company_id INT DEFAULT NULL,                            -- reference to the TABLE company
    individual_description TEXT DEFAULT NULL,
    registered_date DATETIME NOT NULL,
    created_by INT NULL,

    FOREIGN KEY (created_by) REFERENCES crm_user(user_id) ON UPDATE SET NULL ON DELETE SET NULL,
    CONSTRAINT phone_or_email CHECK (phone_number IS NOT NULL OR email_address IS NOT NULL)
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
    company_address VARCHAR(255) NOT NULL,
    company_description TEXT DEFAULT NULL,

    UNIQUE (company_name, company_address) -- make sure no duplicate record
);
-- make attribute `company_id` from table `individual` refer to the `company_id` in the table `company`
ALTER TABLE individual ADD CONSTRAINT FOREIGN KEY (company_id) REFERENCES company(company_id) ON UPDATE SET NULL ON DELETE SET NULL;

-- lead_individual: record which individual is lead and their status
CREATE TABLE lead_individual(
    individual_id INT UNIQUE NOT NULL,
    lead_owner_user_id INT NULL,
    lead_status ENUM("New lead", "Attempted to contact lead", "Contacted lead", "Junk lead", "Lost lead", "Converted to customer") NOT NULL DEFAULT "New lead",

    FOREIGN KEY (lead_owner_user_id) REFERENCES crm_user(user_id) ON UPDATE SET NULL ON DELETE SET NULL
);

-- activity: record the interaction between user and individual
CREATE TABLE activity(
    activity_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    activity_type ENUM("Email", "Call", "Meeting", "Other") NOT NULL DEFAULT "Other",
    start_time DATETIME DEFAULT NULL,
    end_time DATETIME NOT NULL,
    activity_subject VARCHAR(255) NOT NULL,
    activity_description TEXT DEFAULT NULL,
    created_by INT NULL,

    FOREIGN KEY (created_by) REFERENCES crm_user(user_id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT check_time CHECK (start_time <= end_time) -- make sure end time is later than start time
);

-- individual_activity_history: record the activity history of each individual
CREATE TABLE individual_activity_history(
    individual_id INT NOT NULL,
    activity_id INT NOT NULL,

    PRIMARY KEY (individual_id, activity_id),
    FOREIGN KEY (individual_id) REFERENCES individual(individual_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (activity_id) REFERENCES activity(activity_id) ON UPDATE CASCADE ON DELETE CASCADE
);

-- conversion_history: record how each lead / contact switch from one type to another
CREATE TABLE conversion_history(
    conversion_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    user_id INT NOT NULL,
    individual_id INT NOT NULL,
    convert_from ENUM("Contact", "New lead", "Attempted to contact lead", "Contacted lead", "Junk lead", "Lost lead", "Customer") NOT NULL,
    convert_to ENUM("Contact", "New lead", "Attempted to contact lead", "Contacted lead", "Junk lead", "Lost lead", "Customer") NOT NULL,
    convert_time DATETIME NOT NULL,
    conversion_message TEXT NOT NULL,

    FOREIGN KEY (user_id) REFERENCES crm_user(user_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (individual_id) REFERENCES individual(individual_id) ON UPDATE CASCADE ON DELETE CASCADE
);