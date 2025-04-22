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

INSERT INTO company
    VALUES
        (1, "UwU", "UwU Land"),
        (2, "OwO", "OwO Land"),
        (3, "Tokyo tokkyo kyoka kyokucho kyo kyokyo kyoka kyoka kyohi", "Tokyo");

INSERT INTO individual 
        (last_name, first_name, gender, honorifics, relationship, registered_date, company_id)
    VALUES
        ("Tokoyami", "Towa", "Female", "Ms.", "Lead", NOW(), 1),
        ("Tokino", "Sora", "Female", "Ms.", "Lead", NOW(), 2),
        ("Kiryu", "Coco", "Female", "Ms.", "Lead", NOW(), 2),
        ("Hachi", NULL, "Female", "Ms.", "Lead", NOW(), 1),
        ("Natsuiro", "Matsuri", "Female", "Ms.", "Lead", NOW(), 1),
        ("Yuzuka", NULL, "Female", "Ms.", "Lead", NOW(), 1),
        ("Yuni", NULL, "Female", "Ms.", "Lead", NOW(), 1),
        ("Sume", NULL, "Female", "Ms.", "Lead", NOW(), 1),
        ("Dazbee", NULL, "Female", "Ms.", "Lead", NOW(), 1),
        ("Aoiko", NULL, "Female", "Ms.", "Lead", NOW(), 1),
        ("Urara", NULL, "Female", "Ms.", "Lead", NOW(), 1),
        ("Myuk", NULL, "Female", "Ms.", "Lead", NOW(), 2),
        ("Mafumafu", NULL, "Male", "Mr.", "Lead", NOW(), 1),
        ("Yama", NULL, "Female", "Ms.", "Lead", NOW(), 2),
        ("Miyoshino", NULL, "Female", "Ms.", "Lead", NOW(), 1),
        ("Yanami", "Anna", "Female", "Ms.", "Lead", NOW(), 1),
        ("Nukumizu", "Kazuhiko", "Male", "Mr.", "Lead", NOW(), 1),
        ("Meari", NULL, "Female", "Ms.", "Lead", NOW(), 1),
        ("Rosu", NULL, "Female", "Ms.", "Lead", NOW(), 1),
        ("Rokudennashi", NULL, "Female", "Ms.", "Lead", NOW(), 1),
        ("Kasumi", NULL, "Female", "Ms.", "Lead", NOW(), 1),
        ("Ryushen", NULL, "Male", "Mr.", "Lead", NOW(), 2),
        ("Ryugasaki", NULL, "Female", "Ms.", "Lead", NOW(), 1),
        ("Tenma", NULL, "Female", "Ms.", "Lead", NOW(), 2),
        ("Andora", NULL, "Male", "Mr.", "Lead", NOW(), 2),
        ("Konaha", NULL, "Female", "Ms.", "Lead", NOW(), 2),
        ("Guiano", NULL, "Male", "Mr.", "Lead", NOW(), 2),
        ("Hizuki", NULL, "Female", "Ms.", "Lead", NOW(), 1),
        ("Amane", "Ku", "Male", "Mr.", "Lead", NOW(), 2),
        ("Rui", NULL, "Female", "Ms.", "Lead", NOW(), 1),
        ("Orangestar", NULL, "Female", "Ms.", "Lead", NOW(), 1),
        ("Shishigami", "Leona", "Female", "Ms.", "Lead", NOW(), 1),
        ("Yorushika", NULL, "Female", "Ms.", "Lead", NOW(), 1),
        ("Yunayu", NULL, "Female", "Ms.", "Lead", NOW(), 3),
        ("Hyakumantenbara", "Salome", "Female", "Ms.", "Lead", NOW(), 3);

INSERT INTO phone
    VALUES
        (01234567890, "Personal", 1),
        (01234567891, "Personal", 1),
        (01234567892, "Personal", 2);
