INSERT INTO user_role
    VALUES
        (1, "uwu", "yesuwu");

INSERT INTO crm_user 
    VALUES
        (1, "uwu", "uwu", "uwu", 1),
        (2, "owo", "owo", "owo", 1);

INSERT INTO country
    VALUES
        (81, "Japan");

INSERT INTO individual 
        (last_name, gender, honorifics, relationship, registered_date)
    VALUES
        ("tokoyami", "Female", "Ms.", "Lead", NOW()),
        ("tokino", "Female", "Ms.", "Lead", NOW()),
        ("kiryu", "Female", "Ms.", "Lead", NOW());

INSERT INTO phone
    VALUES
        (01234567890, "Personal", 1),
        (01234567891, "Personal", 1),
        (01234567892, "Personal", 2);
