-- drop the old database schema (if exists) and replace it with a new one
DROP DATABASE IF EXISTS uwucrm_abb_db;
CREATE DATABASE uwucrm_abb_db;

-- select the database
USE uwucrm_abb_db;

-- role: used to identify different position of user
CREATE TABLE user_role(
    role_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    role_name VARCHAR(255) NOT NULL,
    role_description TEXT DEFAULT NULL
);

-- user: the person who can log in and access the CRM system
CREATE TABLE user(
    user_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    user_name VARCHAR(255) NOT NULL,
    password_salt CHAR(10) NOT NULL,
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
    user_id INT NOT NULL,
    lead_status ENUM("New", "Attempted to contact", "Contacted", "Junk lead", "Lost lead", "Converted to customer") NOT NULL DEFAULT "New",

    FOREIGN KEY (individual_id) REFERENCES individual(individual_id) ON UPDATE CASCADE ON DELETE CASCADE
);

-- activity: record the interaction between user and individual
CREATE TABLE activity(
    activity_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    activity_type ENUM("Call", "Meeting"),
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    activity_subject VARCHAR(255) NOT NULL,
    activity_description TEXT DEFAULT NULL
);

-- individual_activity_history: record the activity history of each individual
CREATE TABLE individual_activity_history(
    individual_id INT NOT NULL,
    activity_id INT NOT NULL,

    PRIMARY KEY (individual_id, activity_id),
    FOREIGN KEY (individual_id) REFERENCES individual(individual_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (activity_id) REFERENCES activity(activity_id) ON UPDATE CASCADE ON DELETE CASCADE
);

-- user_activity_history: record the activity history of each user
CREATE TABLE user_activity_history(
    user_id INT NOT NULL,
    activity_id INT NOT NULL,

    PRIMARY KEY (user_id, activity_id),
    FOREIGN KEY (user_id) REFERENCES user(user_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (activity_id) REFERENCES activity(activity_id)
);

-- conversion_history: record how each lead / contact switch from one type to another
CREATE TABLE conversion_history(
    conversion_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    user_id INT NOT NULL,
    individual_id INT NOT NULL,
    convert_from ENUM("Contact", "New lead", "Attempted to contact lead", "Contacted lead", "Junk lead", "Lost lead", "Customer") NOT NULL,
    convert_to ENUM("Contact", "New lead", "Attempted to contact lead", "Contacted lead", "Junk lead", "Lost lead", "Customer") NOT NULL,
    convert_time DATETIME NOT NULL,

    FOREIGN KEY (user_id) REFERENCES user(user_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (individual_id) REFERENCES individual(individual_id) ON UPDATE CASCADE ON DELETE CASCADE
);

-- task: record the plan made by the user
CREATE TABLE task(
    task_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    created_by INT NOT NULL,                            -- who created the task (can be admin or sales representative)
    in_charged_by INT NOT NULL,                         -- who is in charged of the task
    created_date DATETIME NOT NULL,
    due_date DATETIME DEFAULT NULL,
    closed_date DATETIME DEFAULT NULL,
    task_priority ENUM("Low", "Normal", "High", "Urgent"),
    task_status ENUM("Not started", "In progress", "Completed", "Cancelled"),
    task_subject VARCHAR(255) NOT NULL,
    task_description TEXT DEFAULT NULL,

    FOREIGN KEY (created_by) REFERENCES user(user_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (in_charged_by) REFERENCES user(user_id) ON UPDATE CASCADE ON DELETE CASCADE
);

-- task_participant: the participant(s) (individual) of assigned task
CREATE TABLE task_participant(
    individual_id INT NOT NULL,
    task_id INT NOT NULL,

    PRIMARY KEY (individual_id, task_id),
    FOREIGN KEY (individual_id) REFERENCES individual(individual_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (task_id) REFERENCES task(task_id) ON UPDATE CASCADE ON DELETE CASCADE
);