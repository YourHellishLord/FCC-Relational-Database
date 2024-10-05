-- echo hello PostgreSQL
-- psql --username=freecodecamp --dbname=postgres
-- \l
CREATE DATABASE first_database;
-- \l
CREATE DATABASE second_database;
-- \l
-- \c second_database
-- \d
CREATE TABLE first_table();
-- \d
CREATE TABLE second_table();
-- \d
-- \d second_table
ALTER TABLE second_table ADD COLUMN first_column INT;
-- \d second_table
ALTER TABLE second_table ADD COLUMN id INT;
-- \d second_table
ALTER TABLE second_table ADD COLUMN age INT;
-- \d second_table
ALTER TABLE second_table DROP COLUMN age;
-- \d second_table
ALTER TABLE second_table DROP COLUMN first_column;
-- \d second_table
ALTER TABLE second_table ADD COLUMN name VARCHAR(30);
-- \d second_table
ALTER TABLE second_table RENAME COLUMN name TO username;
-- \d second_table
INSERT INTO second_table(id, username) VALUES(1, 'Samus');
SELECT * FROM second_table;
INSERT INTO second_table(id, username) VALUES(2, 'Mario');
SELECT * FROM second_table;
INSERT INTO second_table(id, username) VALUES(3, 'Luigi');
SELECT * FROM second_table;
DELETE FROM second_table WHERE username='Luigi';
SELECT * FROM second_table;
DELETE FROM second_table WHERE username='Mario';
DELETE FROM second_table WHERE username='Samus';
SELECT * FROM second_table;
-- \d second_table
ALTER TABLE second_table DROP COLUMN username;
ALTER TABLE second_table DROP COLUMN id;
-- \d
DROP TABLE second_table;
DROP TABLE first_table;
-- \l
ALTER DATABASE first_database RENAME TO mario_database;
-- \l
-- \c mario_database
DROP DATABASE second_database;
-- \l
-- \d
CREATE TABLE characters();
ALTER TABLE characters ADD COLUMN character_id SERIAL;
-- \d characters
ALTER TABLE characters ADD COLUMN name VARCHAR(30) NOT NULL;
ALTER TABLE characters ADD COLUMN homeland VARCHAR(60);
ALTER TABLE characters ADD COLUMN favorite_color VARCHAR(30);
-- \d characters
INSERT INTO characters(name, homeland, favorite_color) VALUES('Mario', 'Mushroom Kingdom', 'Red');
SELECT * FROM characters;
INSERT INTO characters(name, homeland, favorite_color) VALUES('Luigi', 'Mushroom Kingdom', 'Green');
SELECT * FROM characters;
INSERT INTO characters(name, homeland, favorite_color) VALUES('Peach', 'Mushroom Kingdom', 'Pink');
INSERT INTO characters(name, homeland, favorite_color)
VALUES('Toadstool', 'Mushroom Kingdom', 'Red'),
('Bowser', 'Mushroom Kingdom', 'Green');
INSERT INTO characters(name, homeland, favorite_color)
VALUES('Daisy', 'Sarasaland', 'Yellow'),
('Yoshi', 'Dinosaur Land', 'Green');
SELECT * FROM characters;
UPDATE characters SET favorite_color='Orange' WHERE name='Daisy';
SELECT * FROM characters;
UPDATE characters SET name='Toad' WHERE favorite_color='Red';
UPDATE characters SET name='Mario' WHERE character_id=1;
SELECT * FROM characters;
UPDATE characters SET favorite_color='Blue' WHERE name='Toad';
UPDATE characters SET favorite_color='Yellow' WHERE name='Bowser';
UPDATE characters SET homeland='Koopa Kingdom' WHERE name='Bowser';
SELECT * FROM characters;
SELECT * FROM characters ORDER BY character_id;
ALTER TABLE characters ADD PRIMARY KEY(name);
-- \d characters
ALTER TABLE characters DROP CONSTRAINT characters_pkey;
-- \d characters
ALTER TABLE characters ADD PRIMARY KEY(character_id);
-- \d characters
CREATE TABLE more_info();
-- \d
-- \d characters
ALTER TABLE more_info ADD COLUMN more_info_id SERIAL;
ALTER TABLE more_info ADD PRIMARY KEY(more_info_id);
-- \d
ALTER TABLE more_info ADD COLUMN birthday DATE;
ALTER TABLE more_info ADD COLUMN height INT;
ALTER TABLE more_info ADD COLUMN weight NUMERIC(4,1); -- up to 4 digits (1 is decimal precision)
-- \d more_info
ALTER TABLE more_info ADD COLUMN character_id INT REFERENCES characters(character_id);
-- \d more_info
ALTER TABLE more_info ADD UNIQUE(character_id);
ALTER TABLE more_info ALTER COLUMN character_id SET NOT NULL;
-- \d more_info
SELECT character_id FROM characters;
SELECT character_id, name FROM characters;
INSERT INTO more_info(character_id, birthday, height, weight) VALUES(1, '1981-07-09', 155, 64.5);
SELECT * FROM more_info;
SELECT character_id, name FROM characters;
INSERT INTO more_info(character_id, birthday, height, weight) VALUES(2, '1983-07-14', 175, 48.8);
SELECT * FROM more_info;
SELECT character_id, name FROM characters;
INSERT INTO more_info(character_id, birthday, height, weight) VALUES(3, '1985-10-18', 173, 52.2);
SELECT character_id, name FROM characters WHERE name='Toad';
INSERT INTO more_info(character_id, birthday, height, weight) VALUES(4, '1950-01-10', 66, 35.6);
SELECT * FROM more_info;
SELECT character_id, name FROM characters WHERE name='Bowser';
INSERT INTO more_info(character_id, birthday, height, weight) VALUES(5, '1990-10-29', 258, 300);
SELECT character_id, name FROM characters WHERE name='Daisy';
INSERT INTO more_info(character_id, birthday, height, weight) VALUES(6, '1998-07-31', NULL, NULL);
SELECT * FROM more_info;
SELECT character_id, name FROM characters WHERE name='Yoshi';
INSERT INTO more_info(character_id, birthday, height, weight) VALUES(7, '1990-04-13', 162, 59.1);
SELECT * FROM more_info;
ALTER TABLE more_info RENAME COLUMN height TO height_in_cm;
ALTER TABLE more_info RENAME COLUMN weight TO weight_in_kg;
SELECT * FROM more_info;
CREATE TABLE sounds(sound_id SERIAL PRIMARY KEY);
-- \d
ALTER TABLE sounds ADD COLUMN filename VARCHAR(40) UNIQUE NOT NULL;
ALTER TABLE sounds ADD COLUMN character_id INT NOT NULL REFERENCES characters(character_id);
-- \d sounds
SELECT * FROM characters ORDER BY character_id;
INSERT INTO sounds(character_id, filename) VALUES(1, 'its-a-me.wav');
INSERT INTO sounds(character_id, filename) VALUES(1, 'yippee.wav');
INSERT INTO sounds(character_id, filename) VALUES(2, 'ha-ha.wav');
INSERT INTO sounds(character_id, filename) VALUES(2, 'oh-yeah.wav');
INSERT INTO sounds(character_id, filename) VALUES(3, 'yay.wav'), (3, 'woo-hoo.wav');
INSERT INTO sounds(character_id, filename) VALUES(3, 'mm-hmm.wav'), (1, 'yahoo.wav');
SELECT * FROM sounds;
CREATE TABLE actions(action_id SERIAL PRIMARY KEY);
ALTER TABLE actions ADD COLUMN action VARCHAR(20) UNIQUE NOT NULL;
INSERT INTO actions(action) VALUES('run');
INSERT INTO actions(action) VALUES('jump');
INSERT INTO actions(action) VALUES('duck');
SELECT * FROM actions;
CREATE TABLE character_actions();
ALTER TABLE character_actions ADD COLUMN character_id INT NOT NULL;
ALTER TABLE character_actions ADD FOREIGN KEY(character_id) REFERENCES characters(character_id);
-- \d character_actions
ALTER TABLE character_actions ADD COLUMN action_id INT NOT NULL;
ALTER TABLE character_actions ADD FOREIGN KEY(action_id) REFERENCES actions(action_id);
ALTER TABLE character_actions ADD PRIMARY KEY(character_id, action_id);
-- \d character_actions
INSERT INTO character_actions VALUES(7,1),(7,2),(7,3);
SELECT * FROM character_actions;
INSERT INTO character_actions VALUES(6,1),(6,2),(6,3);
INSERT INTO character_actions VALUES(5,1),(5,2),(5,3);
INSERT INTO character_actions VALUES(4,1),(4,2),(4,3);
INSERT INTO character_actions VALUES(3,1),(3,2),(3,3);
INSERT INTO character_actions VALUES(2,1),(2,2),(2,3);
INSERT INTO character_actions VALUES(1,1),(1,2),(1,3);
SELECT * FROM character_actions;
-- \d
SELECT * FROM characters;
SELECT * FROM more_info;
SELECT * FROM characters FULL JOIN more_info ON characters.character_id = more_info.character_id;
SELECT * FROM characters FULL JOIN sounds ON characters.character_id = sounds.character_id;
SELECT * FROM character_actions
    FULL JOIN characters ON character_actions.character_id = characters.character_id
    FULL JOIN actions ON character_actions.action_id = actions.action_id;
