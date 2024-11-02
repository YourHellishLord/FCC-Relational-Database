PSQL="psql --username=freecodecamp --dbname=postgres -t --no-align -c"

echo -e "Dropping old database... $($PSQL "DROP DATABASE IF EXISTS number_guess;")"
echo -e "Creating new database... $($PSQL "CREATE DATABASE number_guess;")"

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo -e "Creating users table..."

echo $($PSQL "\
CREATE TABLE users( \
user_id SERIAL PRIMARY KEY, \
username VARCHAR(22) NOT NULL \
)")

echo -e "Creating games table..."

echo $($PSQL "\
CREATE TABLE games( \
game_id SERIAL PRIMARY KEY, \
user_id INT NOT NULL, \
attempts INT NOT NULL, \
\
FOREIGN KEY (user_id) REFERENCES users(user_id) \
)")

echo -e "\nUSERS TABLE:\n$($PSQL "\d users")"
echo -e "\nGAMES TABLE:\n$($PSQL "\d games")"


# echo -e $($PSQL "INSERT INTO users(username) VALUES ('yhl')")

# echo -e $($PSQL "INSERT INTO games(user_id, attempts) VALUES (1, 3)")
# echo -e $($PSQL "INSERT INTO games(user_id, attempts) VALUES (1, 6)")
# echo -e $($PSQL "INSERT INTO games(user_id, attempts) VALUES (1, 2)")

# echo -e $($PSQL "INSERT INTO users(username) VALUES ('cregles')")

# echo -e $($PSQL "INSERT INTO games(user_id, attempts) VALUES (2, 4)")
# echo -e $($PSQL "INSERT INTO games(user_id, attempts) VALUES (2, 2)")
# echo -e $($PSQL "INSERT INTO games(user_id, attempts) VALUES (2, 3)")
# echo -e $($PSQL "INSERT INTO games(user_id, attempts) VALUES (2, 1)")

PSQL="psql --username=freecodecamp --dbname=number_guess -c"

echo -e "\n\n$($PSQL "SELECT users.username, COUNT(games.attempts) as games_number, MIN(games.attempts) as best_game FROM users INNER JOIN games USING (user_id) GROUP BY users.username")"