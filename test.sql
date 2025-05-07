INSERT INTO user_role
    VALUES
        (1, "Super admin", "All privileges"),
        (2, "Admin", "Able to assign lead to sales representative"),
        (3, "Sales representative", "Able to create lead and manage assigned lead");

INSERT INTO crm_user 
    VALUES
        (1, "UwwwU", 1),
        (2, "OwwwO", 2),
        (3, "Bibidebadeboowa", 3),
        (4, "nananana", 3);

INSERT INTO crm_user_login_info
    VALUES
        (1, "1234567890", "25dc7881a731b7b089e34fae262788b5e77e67a390dcca4928be22422379f4cf"),
        (2, "1234567890", "e3d1bd9701f2e0cc621b55682448b89a8c6b9e984a535084cabcf38613fc6b0e"),
        (3, "uwaaa", "weee"),
        (4, "hmm", "123");

INSERT INTO country
    VALUES
        (81, "Japan");

INSERT INTO company
    VALUES
        (1, "UwU", "UwU Land", 'hololive, hololive Indonesia, hololive English, and hololive DEV_IS are VTuber groups under the VTuber company hololive production, with a combined total of 70 million fans on YouTube.'),
        (2, "OwO", "OwO Land", "We broadcast the weekly 3D animation 'holo no graffiti' that showcases the daily lives of the talents, in addition to variety programs that bring out the talents' charm not ordinarily seen in their usual streams."),
        (3, "Tokyo tokkyo kyoka kyokucho kyo kyokyo kyoka kyoka kyohi", "Tokyo", NULL),
        (4, "Nyanyame nyanyajyuunyanya-do no nyarabi de nyakunyaku", "nya", "Once per turn: You can detach 1 material from this card, then target 1 monster in your opponent's GY; Special Summon it to your opponent's field. If a monster(s) is Special Summoned to your opponent's field, while you control this monster (except during the Damage Step): You can target 1 face-up monster your opponent controls; Special Summon 1 monster with the same Type or Attribute from your hand, Deck, or GY. You can only use this effect of 'Number 29: Mannequin Cat' once per turn."),
        (NULL, "Hololive", "Japan", NULL),
        (NULL, "Bomb bomb", "Mars", NULL),
        (NULL, "Skystriker", "Sentou", "All Sky Striker Spells, with the exception of the Continuous Multirole, Field Area Zero and Quick-Play Lemnis Gate, cannot be activated while you control a Monster in the Main Monster Zones and gain extra effects while you have 3 or more Spell cards in your GY."),
        (NULL, "Unchained", "Soul", NULL),
        (NULL, "Purrely", "Purr", '"Purrely" is a theme focused on using the namesake Level 1 monster "Purrely" to reveal a "Purrely" Quick-Play Spell Card from your hand with its effect, then Special Summoning a Rank 2 Xyz Monster which mentions that Quick-Play Spell in its text using "Purrely" and the revealed card as materials - from there, the objective is to stack further materials onto those Xyz Monsters through their effects. Each of the Rank 2 "Purrely" Xyz Monsters has a unique effect that gains a bonus effect if it has a specific "Purrely" Quick-Play Spell as a material; each one also shares an effect where, thrice per turn as a Quick Effect, you can attach activated "Purrely" Quick-Play Spells to that monster as material with a bonus effect depending on the Rank 2 in question - this varies from temporary removal of cards on the field to changing battle positions.');

INSERT INTO individual 
        (last_name, first_name, gender, honorifics, relationship, registered_date, company_id, phone_number, email_address, individual_description, created_by)
    VALUES
        ("Tokoyami", "Towa", "Female", "Ms.", "Lead", NOW(), 1, "0123456789", NULL, 'A young devil who is visiting human society to gain experience and develop her skills. But instead of studying, she became addicted to video games! After learning about a tool for communicating with humans called "streaming," she is trying it out to help with her studies.', 1),
        ("Tokino", "Sora", "Female", "Ms.", "Lead", NOW(), 2, "0123456790", NULL, 'Tokino Sora (Lit. Sky of Time) is a female Japanese Virtual YouTuber and the founding member of hololive. While she debuted alone way before generations were established, she is currently part of "hololive 0th gen" alongside fellow solo debutants: Roboco-san, Sakura Miko, Hoshimachi Suisei and AZKi.', 1),
        ("Kiryu", "Coco", "Female", "Ms.", "Lead", NOW(), 4, "0123123123", "coco@mail.com", 'Kiryu Coco was a female Japanese Virtual YouTuber associated with hololive, debuting as part of its fourth generation of VTubers alongside Tsunomaki Watame, Tokoyami Towa, Amane Kanata and Himemori Luna. Coco retired in July 2021 with a record-breaking graduation ceremony. She was known for her fluency in Japanese and English, her AsaCoco Live News and Reddit Meme Review shows, and for being the #1 superchat donation earner in the world. ', 1),
        ("Hachi", NULL, "Female", "Ms.", "Lead", NOW(), 1, "01247889131", NULL, 'Virtual Singer "HACHI" "To touch your heart with my voice."', 1),
        ("Natsuiro", "Matsuri", "Female", "Ms.", "Lead", NOW(), 1, NULL, "matsurinatsuiro@mail.com", "'Wasshoi! hololive's symbol of purity and everyone's idol, Natsuiro Matsuri here!'A rookie member of her school cheerleading team. Her cheerful, energetic, and affectionate personality means she gets along with everyone and has lots of friends. Loves festivals, events, and other fun things.", 1),
        ("Yuzuka", NULL, "Female", "Ms.", "Lead", NOW(), NULL, "0121231289", NULL, NULL, 1),
        ("Yuni", NULL, "Female", "Ms.", "Lead", NOW(), 4, "0124213789", NULL, NULL, 1),
        ("Sume", NULL, "Female", "Ms.", "Lead", NOW(), 7, "011231389", NULL, NULL, 1),
        ("Dazbee", NULL, "Female", "Ms.", "Lead", NOW(), 1, NULL, "dazbee@mail.com", NULL, 1),
        ("Aoiko", NULL, "Female", "Ms.", "Lead", NOW(), 8, NULL, "aoiko@mail.com", NULL, 1),
        ("Urara", NULL, "Female", "Ms.", "Lead", NOW(), 4, NULL, "urara@mail.com", NULL, 1),
        ("Myuk", NULL, "Female", "Ms.", "Lead", NOW(), 2, NULL, "myukkkk@mail.com", NULL, 1),
        ("Mafumafu", NULL, "Male", "Mr.", "Lead", NOW(), 9, "0123491923", NULL, NULL, 1),
        ("Yama", NULL, "Female", "Ms.", "Lead", NOW(), 2, NULL, "yamaaa@mail.com", NULL, 1),
        ("Miyoshino", NULL, "Female", "Ms.", "Lead", NOW(), 1, NULL, "miyomiyo@mail.com", NULL, 1),
        ("Yanami", "Anna", "Female", "Ms.", "Lead", NOW(), 6, "0123467654", "yanamiii@mail.com", NULL, 1),
        ("Nukumizu", "Kazuhiko", "Male", "Mr.", "Lead", NOW(), 1, "0128319312", "nukuhiko@mail.com", NULL, 1),
        ("Meari", NULL, "Female", "Ms.", "Lead", NOW(), 7, "01231224319", NULL, NULL, 1),
        ("Rosu", NULL, "Female", "Ms.", "Lead", NOW(), 1, "0138929221", NULL, NULL, 1),
        ("Rokudennashi", NULL, "Female", "Ms.", "Lead", NOW(), 1, "0123412131", "rokuden@mail.com", NULL, 1),
        ("Kasumi", NULL, "Female", "Ms.", "Lead", NOW(), 7, "0123213111", "kasu@mail.com", NULL, 1),
        ("Ryushen", NULL, "Male", "Mr.", "Lead", NOW(), 2, NULL, "ryushen11@mail.com", NULL, 1),
        ("Ryugasaki", NULL, "Female", "Ms.", "Lead", NOW(), 1, NULL, "ryuuugasaki@mail.com", NULL, 1),
        ("Tenma", NULL, "Female", "Ms.", "Lead", NOW(), 2, "01234535667", "tennnn@mail.com", NULL, 1),
        ("Andora", NULL, "Male", "Mr.", "Lead", NOW(), 6, "012678567331", "andora@mail.com", NULL, 1),
        ("Konaha", NULL, "Female", "Ms.", "Lead", NOW(), 8, NULL, "konoha@mail.com", NULL, 1),
        ("Guiano", NULL, "Male", "Mr.", "Lead", NOW(), 2, NULL, "guiano@mail.com", NULL, 1),
        ("Hizuki", NULL, "Female", "Ms.", "Lead", NOW(), 1, "0123637812", NULL, NULL, 1),
        ("Amane", "Ku", "Male", "Mr.", "Lead", NOW(), 2, "014212789", NULL, NULL, 1),
        ("Rui", NULL, "Female", "Ms.", "Lead", NOW(), 4, "0151126789", NULL, NULL, 1),
        ("Orangestar", NULL, "Female", "Ms.", "Lead", NOW(), 1, "011232789", NULL, NULL, 1),
        ("Shishigami", "Leona", "Female", "Ms.", "Lead", NOW(), 6, NULL, "leona@mail.com", NULL, 1),
        ("Yorushika", NULL, "Female", "Ms.", "Lead", NOW(), 1, NULL, "yorushika@mail.com", NULL, 1),
        ("Tayori", NULL, "Female", "Ms.", "Contact", NOW(), 3, NULL, "tayori@mail.com", NULL, 1),
        ("Hanon", NULL, "Female", "Ms.", "Contact", NOW(), 3, NULL, "hanon@mail.com", NULL, 1),
        ("Hoshikawa", NULL, "Female", "Ms.", "Contact", NOW(), 3, NULL, "hoshiiisara@mail.com", NULL, 1),
        ("Yunayu", NULL, "Female", "Ms.", "Lead", NOW(), 3, NULL, "yunayu@mail.com", NULL, 1),
        ("Hyakumantenbara", "Salome", "Female", "Ms.", "Lead", NOW(), 3, NULL, "hyakumantensalome@mail.com", NULL, 1);

INSERT INTO lead_individual
        (individual_id, lead_owner_user_id)
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
        (30, 3);

INSERT INTO activity
        (activity_type, start_time, end_time, activity_subject, created_by)
    VALUES
        ("Meeting", "2024-12-03 11:28:09", "2024-12-03 12:28:09", "Meeting dayo", 1),
        ("Meeting", "2023-01-23 6:28:09", "2023-01-23 7:08:23", "Some meeting idk", 1),
        ("Call", "2021-09-17 10:12:39", "2021-09-17 10:18:21", "Call with client", 1);

-- UPDATE lead_individual SET lead_status = 'Contacted' WHERE individual_id = 6;