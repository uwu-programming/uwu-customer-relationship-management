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
        (3, "Tokyo tokkyo kyoka kyokucho kyo kyokyo kyoka kyoka kyohi", "Tokyo"),
        (4, "Nyanyame nyanyajyuunyanya-do no nyarabi de nyakunyaku inyanyaku nyanyahan nyanyadai nyanynaku nyarabete nyaganyagame", "nya"),
        (NULL, "Hololive", "Japan"),
        (NULL, "Bomb bomb", "Mars"),
        (NULL, "Skystriker", "Sentou"),
        (NULL, "Unchained", "Soul"),
        (NULL, "Purrely", "Purr");

INSERT INTO individual 
        (last_name, first_name, gender, honorifics, relationship, registered_date, company_id)
    VALUES
        ("Tokoyami", "Towa", "Female", "Ms.", "Lead", NOW(), 1),
        ("Tokino", "Sora", "Female", "Ms.", "Lead", NOW(), 2),
        ("Kiryu", "Coco", "Female", "Ms.", "Lead", NOW(), 4),
        ("Hachi", NULL, "Female", "Ms.", "Lead", NOW(), 1),
        ("Natsuiro", "Matsuri", "Female", "Ms.", "Lead", NOW(), 1),
        ("Yuzuka", NULL, "Female", "Ms.", "Lead", NOW(), 4),
        ("Yuni", NULL, "Female", "Ms.", "Lead", NOW(), 4),
        ("Sume", NULL, "Female", "Ms.", "Lead", NOW(), 3),
        ("Dazbee", NULL, "Female", "Ms.", "Lead", NOW(), 1),
        ("Aoiko", NULL, "Female", "Ms.", "Lead", NOW(), 8),
        ("Urara", NULL, "Female", "Ms.", "Lead", NOW(), 4),
        ("Myuk", NULL, "Female", "Ms.", "Lead", NOW(), 2),
        ("Mafumafu", NULL, "Male", "Mr.", "Lead", NOW(), 9),
        ("Yama", NULL, "Female", "Ms.", "Lead", NOW(), 2),
        ("Miyoshino", NULL, "Female", "Ms.", "Lead", NOW(), 1),
        ("Yanami", "Anna", "Female", "Ms.", "Lead", NOW(), 6),
        ("Nukumizu", "Kazuhiko", "Male", "Mr.", "Lead", NOW(), 1),
        ("Meari", NULL, "Female", "Ms.", "Lead", NOW(), 7),
        ("Rosu", NULL, "Female", "Ms.", "Lead", NOW(), 1),
        ("Rokudennashi", NULL, "Female", "Ms.", "Lead", NOW(), 1),
        ("Kasumi", NULL, "Female", "Ms.", "Lead", NOW(), 7),
        ("Ryushen", NULL, "Male", "Mr.", "Lead", NOW(), 2),
        ("Ryugasaki", NULL, "Female", "Ms.", "Lead", NOW(), 1),
        ("Tenma", NULL, "Female", "Ms.", "Lead", NOW(), 2),
        ("Andora", NULL, "Male", "Mr.", "Lead", NOW(), 6),
        ("Konaha", NULL, "Female", "Ms.", "Lead", NOW(), 8),
        ("Guiano", NULL, "Male", "Mr.", "Lead", NOW(), 2),
        ("Hizuki", NULL, "Female", "Ms.", "Lead", NOW(), 1),
        ("Amane", "Ku", "Male", "Mr.", "Lead", NOW(), 2),
        ("Rui", NULL, "Female", "Ms.", "Lead", NOW(), 4),
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
