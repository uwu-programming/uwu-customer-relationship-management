INSERT INTO user_role
    VALUES
        (1, "uwu", "yesuwu"),
        (2, "owo", "partly yes uwu");

INSERT INTO crm_user 
    VALUES
        (1, "uwu", "uwu", "uwu", 1),
        (2, "owo", "owo", "owo", 2),
        (3, "Bibidebadeboowa", "uwaaa", "weeee", 2);

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
        (last_name, first_name, gender, honorifics, relationship, registered_date, company_id, phone_number, email_address)
    VALUES
        ("Tokoyami", "Towa", "Female", "Ms.", "Lead", NOW(), 1, "0123456789", NULL),
        ("Tokino", "Sora", "Female", "Ms.", "Lead", NOW(), 2, "0123456790", NULL),
        ("Kiryu", "Coco", "Female", "Ms.", "Lead", NOW(), 4, "0123123123", "coco@mail.com"),
        ("Hachi", NULL, "Female", "Ms.", "Lead", NOW(), 1, "01247889131", NULL),
        ("Natsuiro", "Matsuri", "Female", "Ms.", "Lead", NOW(), 1, NULL, "matsurinatsuiro@mail.com"),
        ("Yuzuka", NULL, "Female", "Ms.", "Lead", NOW(), 4, "0121231289", NULL),
        ("Yuni", NULL, "Female", "Ms.", "Lead", NOW(), 4, "0124213789", NULL),
        ("Sume", NULL, "Female", "Ms.", "Lead", NOW(), 7, "011231389", NULL),
        ("Dazbee", NULL, "Female", "Ms.", "Lead", NOW(), 1, NULL, "dazbee@mail.com"),
        ("Aoiko", NULL, "Female", "Ms.", "Lead", NOW(), 8, NULL, "aoiko@mail.com"),
        ("Urara", NULL, "Female", "Ms.", "Lead", NOW(), 4, NULL, "urara@mail.com"),
        ("Myuk", NULL, "Female", "Ms.", "Lead", NOW(), 2, NULL, "myukkkk@mail.com"),
        ("Mafumafu", NULL, "Male", "Mr.", "Lead", NOW(), 9, "0123491923", NULL),
        ("Yama", NULL, "Female", "Ms.", "Lead", NOW(), 2, NULL, "yamaaa@mail.com"),
        ("Miyoshino", NULL, "Female", "Ms.", "Lead", NOW(), 1, NULL, "miyomiyo@mail.com"),
        ("Yanami", "Anna", "Female", "Ms.", "Lead", NOW(), 6, "0123467654", "yanamiii@mail.com"),
        ("Nukumizu", "Kazuhiko", "Male", "Mr.", "Lead", NOW(), 1, "0128319312", "nukuhiko@mail.com"),
        ("Meari", NULL, "Female", "Ms.", "Lead", NOW(), 7, "01231224319", NULL),
        ("Rosu", NULL, "Female", "Ms.", "Lead", NOW(), 1, "0138929221", NULL),
        ("Rokudennashi", NULL, "Female", "Ms.", "Lead", NOW(), 1, "0123412131", "rokuden@mail.com"),
        ("Kasumi", NULL, "Female", "Ms.", "Lead", NOW(), 7, "0123213111", "kasu@mail.com"),
        ("Ryushen", NULL, "Male", "Mr.", "Lead", NOW(), 2, NULL, "ryushen11@mail.com"),
        ("Ryugasaki", NULL, "Female", "Ms.", "Lead", NOW(), 1, NULL, "ryuuugasaki@mail.com"),
        ("Tenma", NULL, "Female", "Ms.", "Lead", NOW(), 2, "01234535667", "tennnn@mail.com"),
        ("Andora", NULL, "Male", "Mr.", "Lead", NOW(), 6, "012678567331", "andora@mail.com"),
        ("Konaha", NULL, "Female", "Ms.", "Lead", NOW(), 8, NULL, "konoha@mail.com"),
        ("Guiano", NULL, "Male", "Mr.", "Lead", NOW(), 2, NULL, "guiano@mail.com"),
        ("Hizuki", NULL, "Female", "Ms.", "Lead", NOW(), 1, "0123637812", NULL),
        ("Amane", "Ku", "Male", "Mr.", "Lead", NOW(), 2, "014212789", NULL),
        ("Rui", NULL, "Female", "Ms.", "Lead", NOW(), 4, "0151126789", NULL),
        ("Orangestar", NULL, "Female", "Ms.", "Lead", NOW(), 1, "011232789", NULL),
        ("Shishigami", "Leona", "Female", "Ms.", "Lead", NOW(), 6, NULL, "leona@mail.com"),
        ("Yorushika", NULL, "Female", "Ms.", "Lead", NOW(), 1, NULL, "yorushika@mail.com"),
        ("Yunayu", NULL, "Female", "Ms.", "Lead", NOW(), 3, NULL, "yunayu@mail.com"),
        ("Hyakumantenbara", "Salome", "Female", "Ms.", "Lead", NOW(), 3, NULL, "hyakumantensalome@mail.com");

INSERT INTO lead_individual
        (individual_id, user_id)
    VALUES
        (1, 2),
        (2, 2),
        (3, 2),
        (4, 3),
        (5, 3),
        (6, 3),
        (7, 2),
        (8, 2),
        (9, 3),
        (10, 2),
        (11, 3),
        (12, 2),
        (13, 2),
        (14, 2),
        (15, 3),
        (16, 3),
        (17, 2),
        (18, 2),
        (19, 3),
        (20, 3),
        (21, 2),
        (22, 2),
        (23, 3),
        (24, 2),
        (25, 2),
        (26, 2),
        (27, 3),
        (28, 2),
        (29, 2),
        (30, 3),
        (31, 3),
        (32, 3),
        (33, 3),
        (34, 3),
        (35, 3);
