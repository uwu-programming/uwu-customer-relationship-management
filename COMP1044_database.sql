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
    last_name VARCHAR(255) DEFAULT NULL,
    gender ENUM("Male", "Female") NOT NULL,
    honorifics ENUM("Mr.", "Ms.", "Mrs.", "Dr.", "Prof.") NOT NULL,
    relationship ENUM("Contact", "Lead", "Customer") NOT NULL DEFAULT "Contact",
    phone_number VARCHAR(255) UNIQUE DEFAULT NULL,
    email_address VARCHAR(255) UNIQUE DEFAULT NULL,
    country_code INT DEFAULT NULL,                          -- reference to the TABLE country
    company_id INT DEFAULT NULL,                            -- reference to the TABLE company
    individual_description TEXT DEFAULT NULL,
    registered_date DATETIME NOT NULL,
    created_by INT NULL,

    FOREIGN KEY (created_by) REFERENCES crm_user(user_id) ON UPDATE SET NULL ON DELETE SET NULL,
    CONSTRAINT first_or_last_name CHECK (first_name IS NOT NULL OR last_name IS NOT NULL),
    CONSTRAINT phone_or_email CHECK (phone_number IS NOT NULL OR email_address IS NOT NULL)
);

-- country: store the country code with respect to country name
CREATE TABLE country(
    country_code INT PRIMARY KEY NOT NULL,
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









-- sample data
INSERT INTO user_role
    VALUES
        (1, "Super admin", "All privileges"),
        (2, "Admin", "Able to assign lead to sales representative"),
        (3, "Sales representative", "Able to create lead and manage assigned lead");

INSERT INTO crm_user 
    VALUES
        (1, "Myuk", 1),
        (2, "Rin Katari", 2),
        (3, "Koto Sakura Riko", 2),
        (4, "Hachi", 3),
        (5, "Maru", 3),
        (6, "Cereus", 3),
        (7, "Kasumi", 3);

INSERT INTO crm_user_login_info
    VALUES
        (1, "90oplajdyu", "8eb806b136dc5f0d9350b381ce12aca92d20c5cfa41abf088e77a3d346786fb3"),
        (2, "lma23tyuai", "cea7a2c988c8b33be188c7c30d42d9e102878f89afb7d8c98701f74ed58aefa6"),
        (3, "nh1adsghcv", "a02cad2d7458a22721b76bf5ca915164aab9546b113a09981a08ab41d1f6739b"),
        (4, "tgdva128ql", "b151a9f9545bae7aefc8d51466d35c9e29d7b34f909047c1319ebda539e12c55"),
        (5, "bvfqw712ao", "9fb610c07121ffdd44e6a5aec19c5cc374a54921b9d0bc2ded40e4fbd56b4886"),
        (6, "1lmadgca47", "ed72e2650358e9f6e1ad2cc15e7e80a133fd5e84377fad7158d7a60578daee56"),
        (7, "vctqia918p", "eacec99cc33b4b7111e590bba1c4f4cebf6490db8c154f4c8dc310ad5b66604b");

INSERT INTO country
    VALUES
        (93, "Afghanistan"),
        (355, "Albania"),
        (213, "Algeria"),
        (1684, "American Samoa"),
        (376, "Andorra"),
        (244, "Angola"),
        (1264, "Anguilla"),
        (672, "Antarctica"),
        (1268, "Antigua and Barbuda"),
        (54, "Argentina"),
        (374, "Armenia"),
        (297, "Aruba"),
        (61, "Australia"),
        (43, "Austria"),
        (994, "Azerbaijan"),
        (1242, "Bahamas"),
        (973, "Bahrain"),
        (880, "Bangladesh"),
        (1246, "Barbados"),
        (375, "Belarus"),
        (32, "Belgium"),
        (501, "Belize"),
        (229, "Belize"),
        (1441, "Bermuda"),
        (975, "Bhutan"),
        (591, "Bolivia"),
        (387, "Bosnia and Herzegovina"),
        (267, "Botswana"),
        (55, "Brazil"),
        (246, "British Indian Ocean Territory"),
        (1284, "British Virgin Islands"),
        (673, "Brunei"),
        (359, "Bulgaria"),
        (226, "Burkina Faso"),
        (257, "Burundi"),
        (855, "Cambodia"),
        (237, "Cameroon"),
        (238, "Canada"),
        (1345, "Cayman Islands"),
        (236, "Central African Republic"),
        (235, "Chad"),
        (56, "AlbChileania"),
        (86, "China"),
        (57, "Colombia"),
        (269, "Comoros"),
        (682, "Cook Islands"),
        (506, "Costa Rica"),
        (385, "Croatia"),
        (53, "Cuba"),
        (357, "Cyprus"),
        (420, "Czech Republic"),
        (243, "Democratic Republic of the Congo"),
        (45, "Denmark"),
        (1809, "Dominican Republic"),
        (670, "East Timor"),
        (593, "Ecuador"),
        (20, "Egypt"),
        (503, "El Salvador"),
        (240, "Equatorial Guinea"),
        (291, "Eritrea"),
        (372, "Estonia"),
        (251, "Ethiopia"),
        (500, "Falkland Islands"),
        (298, "Faroe Islands"),
        (679, "Fiji"),
        (358, "Finland"),
        (33, "France"),
        (689, "French Polynesia"),
        (241, "Gabon"),
        (220, "Gambia"),
        (995, "Georgia"),
        (49, "Germany"),
        (233, "Ghana"),
        (350, "Gibraltar"),
        (30, "Greece"),
        (299, "Greenland"),
        (1473, "Grenada"),
        (1671, "Guam"),
        (502, "Guatemala"),
        (441481, "Guernsey"),
        (224, "Guinea"),
        (245, "Guinea-Bissau"),
        (592, "Guyana"),
        (509, "Haiti"),
        (504, "Honduras"),
        (852, "Hong Kong"),
        (36, "Hungary"),
        (354, "Iceland"),
        (91, "India"),
        (62, "Indonesia"),
        (98, "Iran"),
        (964, "Iraq"),
        (353, "Ireland"),
        (441624, "Isle of Man"),
        (972, "Israel"),
        (39, "Italy"),
        (225, "Ivory Coast"),
        (1876, "Jamaica"),
        (81, "Japan"),
        (441534, "Jersey"),
        (962, "Jordan"),
        (254, "Kenya"),
        (686, "Kiribati"),
        (383, "Kosovo"),
        (965, "Kuwait"),
        (996, "Kyrgyzstan"),
        (856, "Laos"),
        (371, "Latvia"),
        (961, "Lebanon"),
        (266, "Lesotho"),
        (231, "Liberia"),
        (218, "Libya"),
        (423, "Liechtenstein"),
        (370, "Lithuania"),
        (352, "Luxembourg"),
        (853, "Macau"),
        (389, "Macedonia"),
        (261, "Madagascar"),
        (265, "Malawi"),
        (60, "Malaysia"),
        (960, "Maldives"),
        (223, "Mali"),
        (356, "Malta"),
        (692, "Marshall Islands"),
        (222, "Mauritania"),
        (230, "Mauritius"),
        (52, "Mexico"),
        (691, "Micronesia"),
        (373, "Moldova"),
        (377, "Monaco"),
        (976, "Mongolia"),
        (382, "Montenegro"),
        (1664, "Montserrat"),
        (212, "Morocco"),
        (258, "Mozambique"),
        (95, "Myanmar"),
        (264, "Namibia"),
        (674, "Nauru"),
        (977, "Nepal"),
        (31, "Netherlands"),
        (599, "Netherlands Antilles"),
        (687, "New Caledonia"),
        (64, "New Zealand"),
        (505, "Nicaragua"),
        (227, "Niger"),
        (234, "Nigeria"),
        (683, "Niue"),
        (850, "North Korea"),
        (1670, "Northern Mariana Islands"),
        (47, "Norway"),
        (968, "Oman"),
        (92, "Pakistan"),
        (680, "Palau"),
        (970, "Palestine"),
        (507, "Panama"),
        (675, "Papua New Guinea"),
        (595, "Paraguay"),
        (51, "Peru"),
        (63, "Philippines"),
        (48, "Poland"),
        (351, "Portugal"),
        (1787, "Puerto Rico"),
        (974, "Qatar"),
        (242, "Republic of the Congo"),
        (262, "Reunion"),
        (40, "Romania"),
        (7, "Russia"),
        (250, "Rwanda"),
        (590, "Saint Barthelemy"),
        (290, "Saint Helena"),
        (1869, "Saint Kitts and Nevis"),
        (1758, "Saint Lucia"),
        (508, "Saint Pierre and Miquelon"),
        (1784, "Saint Vincent and the Grenadines"),
        (685, "Samoa"),
        (378, "San Marino"),
        (239, "PakistSao Tome and Principean"),
        (966, "Saudi Arabia"),
        (221, "Senegal"),
        (381, "Serbia"),
        (248, "Seychelles"),
        (232, "Sierra Leone"),
        (65, "Singapore"),
        (1721, "Sint Maarten"),
        (421, "Slovakia"),
        (386, "Slovenia"),
        (677, "Solomon Islands"),
        (252, "Somalia"),
        (27, "South Africa"),
        (82, "South Korea"),
        (211, "South Sudan"),
        (34, "Spain"),
        (94, "Sri Lanka"),
        (249, "Sudan"),
        (597, "Suriname"),
        (268, "Swaziland"),
        (46, "Sweden"),
        (41, "Switzerland"),
        (963, "Syria"),
        (886, "Taiwan"),
        (992, "Tajikistan"),
        (255, "Tanzania"),
        (66, "Thailand"),
        (228, "Togo"),
        (690, "Tokelau"),
        (676, "Tonga"),
        (1868, "Trinidad and Tobago"),
        (216, "Tunisia"),
        (90, "Turkey"),
        (993, "Turkmenistan"),
        (1649, "Turks and Caicos Islands"),
        (688, "Tuvalu"),
        (1340, "SpaU.S. Virgin Islandsin"),
        (256, "Uganda"),
        (380, "Ukraine"),
        (971, "United Arab Emirates"),
        (44, "United Kingdom"),
        (1, "United States"),
        (598, "Uruguay"),
        (998, "Uzbekistan"),
        (678, "Vanuatu"),
        (379, "Vatican"),
        (58, "Venezuela"),
        (84, "Vietnam"),
        (681, "Wallis and Futuna"),
        (967, "Yemen"),
        (260, "SpaZambiain"),
        (263, "Zimbabwe");

INSERT INTO company
    VALUES
        (NULL, "VShojo", "San Francisco, California, United States", "VShojo is a US-based VTuber agency headquartered in San Francisco. As of April 2025, the organization has 17 members with a combined 6.4 million followers on Twitch and a combined 7.5 million subscribers on YouTube. The company relies on cutting edge technology on real-time 3D body movement tracking and face tracking."),
        (NULL, "COVER Corporation", "Tokyo Mita Garden Tower, 3-5-19, Mita, Minato-ku, Tokyo, 108-0073 Japan", "COVER Corporation is a Japanese company known for operating Hololive Production, a large VTuber agency, and for producing other 2D entertainment content. The company was founded in 2016 with the goal of creating online virtual spaces where people can communicate through games, concerts, and other entertainment. The company requires cutting edge technology in recording and stage management."),
        (NULL, "Shionogi Pharmaceuticals", "1-8, Doshomachi 3-chome, Chuo-ku, Osaka 541-0045, Japan", "Shionogi & Co., Ltd. is a Japanese pharmaceutical company with a global presence, and its European headquarters are known as Shionogi B.V. Shionogi also has offices in Hong Kong, Taiwan, and China. The company's origins date back to 1878 when Gisaburo Shiono established a drug wholesale business in Osaka."),
        (NULL, "Phase-Connect", "Virtual", "Phase-Connect is an English-Japanese Virtual YouTuber agency based in Vancouver, Canada. Their goal is to connect people across the globe with lots of fun and laughter. The company is looking for cutting edge technology in recording and movement tracking."),
        (NULL, "Bibbideba Concert Agency", "7-5, Sotokanda 1-chome, Chiyoda-ku, Tokyo 101-8618, Japan", "Bibbideba is a concert hosting agency, they are in charged of setting up the stage and environment for the event. They are looking for automated robotics solution for carrying and transfer heavy material."),
        (NULL, "International Union for the Protection of New Varieties of Plants (UPOV)", "34, chemin des Colombettes CH-1211 Genève 20 Switzerland", "UPOV's mission is to provide and promote an effective system of plant variety protection, with the aim of encouraging the development of new varieties of plants, for the benefit of society."),
        (NULL, "Bioform Technologies", "666 Burrard Street V6C 2X8 Vancouver, BC Canada", "Founded in 2021, Bioform has developed a proprietary method to manufacture plastic alternatives based on wood pulp reinforced hydrogels at high speeds by modifying existing pulp and paper making machinery. The manufacturing process has a low carbon footprint and can produce highly versatile materials to replace a wide range of single use plastics. Bioform has developed both compostable and paper-recyclable films that can be heat sealed or thermoformed depending on the application."),
        (NULL, "Yusen Logistics Do Brasil Ltda.", "Rodovia Anhanguera, Km 26 + 421m, Perus, Brasil", "Founded in 1955, Yusen Logistics is a global supply chain logistics company that provides ocean and air freight forwarding, warehousing, distribution services, and supply chain management a seamlessly connected suite of supply chain solutions that delivers superior value, reliability, and expertise.");

INSERT INTO individual 
        (last_name, middle_name, first_name, gender, honorifics, relationship, registered_date, company_id, country_code, phone_number, email_address, individual_description, created_by)
    VALUES
        (NULL, NULL, "Kson", "Female", "Ms.", "Contact", "2025-04-07T10:26:18+00:00", 1, 81, NULL, "kson@vshojo.com", NULL, 1),
        ("Fortunat", "MowtenDoo", "Phillip", "Male", "Mr.", "Lead", "2025-02-17T09:18:13+00:00", 1, 1, NULL, "mowtendoooo@vshojo.com", "The CTO of VShojo, looking for cutting edge technology in 3D movement tracking.", 2),
        ("Shionogi", NULL, "Kanade", "Female", "Ms.", "Lead", "2025-01-08T14:31:24+00:00", 3, 81, NULL, "kanadepharma@mail.com", "Shionogi Kanade supports people's health promotion and provides contents to deliver information related to medicines easier to understand and enjoyable.", 3),
        ("Hoshimaci", NULL, "Suisei", "Female", "Ms.", "Customer", "2025-03-22T16:22:38+00:00", 5, 81, NULL, "suichan@bibideba.com", "Suisei is an active customer of ABB, looking for cutting edge technology that helps with automated heavy items carry and transfer.", 3),
        ("Tanigo", NULL, "Motoaki", "Male", "Mr.", "Lead", "2025-02-18T11:19:54+00:00", 2, 81, NULL, "yagoo@cover.com", "Mr Tanigo is looking for automated solution in 3D movement tracking.", 2),
        ("Ikko", NULL, "Fukuda", "Male", "Mr.", "Lead", "2025-01-12T16:11:34+00:00", 2, 81, NULL, "fukudaikko@cover.com", "Mr Ikko is the CTO of Cover Corporation. He is looking for solution in automated recording for movement detection.", 2),
        (NULL, NULL, "Sakana", "Male", "Mr.", "Customer", "2024-11-24T11:18:44+00:00", 4, 1, NULL, "sakana@phasec.com", "Mr Sakana is a long time customer of ABB, he is interested in high quality automated recording system.", 4),
        ("Lamont", "Robert", "Marc", "Male", "Mr.", "Lead", "2024-12-02T14:12:17+00:00", NULL, 44, NULL, "caedrel@businessmail.com", "Mr Marc is looking for automated solution to help deal with rats problem for his farm business.", 4),
        ("Galabov", "Hylissang", "Zdravets", "Male", "Prof.", "Lead", "2024-11-28T09:36:27+00:00", NULL, 359, NULL, "hylissang@inta.com", "Professor Zdravets is looking for automated solution to help him automated garbage throwing process.", 7),
        ("Ji hoon", "Chovy", "Jeong", "Male", "Mr.", "Lead", "2024-10-11T13:16:39+00:00", 6, 82, NULL, "chovyyyy@farming.com", "Mr Jeong is looking for robotics solution to help him in his farming business.", 6),
        ("Ange", NULL, "Katrina", "Female", "Prof.", "Lead", "2025-02-14T11:39:17+00:00", 7, 81, NULL, "katrina@alchemy.com", "Professor Ange is looking for automate solution to help with her biotechnolgy business.", 5),
        ("Kureiji", NULL, "Ollie", "Female", "Prof.", "Lead", "2025-01-13T16:19:57+00:00", 8, 62, NULL, "ollie@logistic.com", "Professor Ollie is looking for automated solution to help with her logistics business.", 5),
        ("Tokino", NULL, "Sora", "Female", "Ms.", "Lead", "2024-10-10T15:23:42+00:00", 5, 61, NULL, "soraaa@music.com", "Ms Tokino is looking for automated solution for stage lighting management for her concert management business.", 7),
        ("Asahi", NULL, "Lina", "Female", "Prof.", "Lead", "2024-09-18T19:18:17+00:00", NULL, 61, NULL, "asahilina@dev.com", "Professor Lina is looking for automated robotic solution for silicone production project.", 3),
        (NULL, NULL, "Luna", "Female", "Prof.", "Lead", "2025-03-11T14:28:47+00:00", NULL, 45, NULL, "lunafox@inochi.com", "Professor Luna specialized in computer chip development, she is looking for an automated robotic solution for chip production.", 2),
        ("Shuhei", NULL, "Ueda", "Male", "Mr.", "Customer", "2024-10-19T11:38:21+00:00", 2, 81, NULL, "shuheieuda@cover.com", "Mr Shuhei is an active customer of ABB. He is interested in cutting edge solution in automated security system", 2);


INSERT INTO lead_individual
        (individual_id, lead_owner_user_id)
    VALUES
        (2, 5),
        (3, 7),
        (5, 6),
        (6, 6),
        (8, 4),
        (9, 7),
        (10, 6),
        (11, 5),
        (12, 5),
        (13, 7),
        (14, 4),
        (15, 4);
        

INSERT INTO activity
        (activity_type, start_time, end_time, activity_subject, activity_description, created_by)
    VALUES
        ("Meeting", "2025-02-18T09:11:13+00:00", "2025-02-18T10:21:33+00:00", "Meeting with Mr Phillip", "Discussion about potential solution to offer for 3D movement tracking.", 5),
        ("Call", "2025-02-21T19:31:28+00:00", "2025-02-21T19:39:31+00:00", "Call with Mr Phillip", "Discussion about next meeting schedule.", 5),
        ("Meeting", "2025-03-01T13:38:33+00:00", "2025-03-01T15:29:19+00:00", "Meeting with Mr Phillip", "Discussion about 3D movement tracking functional requirement.", 5),
        ("Meeting", "2024-11-30T12:16:17+00:00", "2024-11-30T14:29:47+00:00", "Meeting with Mr Zdravets", "Discussion about automated throwing solution.", 7),
        ("Meeting", "2024-12-02T10:37:24+00:00", "2024-12-02T13:13:39+00:00", "Meeting with Mr Zdravets", "Discussion about automated throwing robot design.", 7),
        ("Meeting", "2025-02-23T09:10:17+00:00", "2025-02-23T13:47:59+00:00", "Meeting with Mr Tanigo and Mr Ikko", "Discussion about potential solution for automated recording and movement tracking.", 6);

INSERT INTO individual_activity_history
    VALUES
        (2, 1),
        (2, 2),
        (2, 3),
        (9, 4),
        (9, 5),
        (5, 6),
        (6, 6);
