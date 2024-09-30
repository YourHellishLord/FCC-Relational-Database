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
SELECT * From second_table;
INSERT INTO second_table(id, username) VALUES(2, 'Mario');
SELECT * From second_table;
INSERT INTO second_table(id, username) VALUES(3, 'Luigi');
SELECT * From second_table;
