#!/bin/bash

DB_USERNAME="freecodecamp"
CSV_FILE="games.csv"

if [[ $1 == "test" ]]
then
  DB_NAME="worldcuptest"

else
  DB_NAME="worldcup"
fi

PSQL="psql --username=$DB_USERNAME --dbname=$DB_NAME -t --no-align -c"

# Do not change code above this line. Use the PSQL variable above to query your database.

echo -e "\n~~ GAMES DATA INSERTION ~~\n"

# Resetting to default

echo -e "\nDropping database $DB_NAME..."
echo "$(psql --username=$DB_USERNAME -t --no-align -c "DROP DATABASE IF EXISTS $DB_NAME")"
echo -e "\nCreating database $DB_NAME..."
echo "$(psql --username=$DB_USERNAME -t --no-align -c "CREATE DATABASE $DB_NAME")"

# Creating tables

echo -e "\n~~~~~~~~~~~~~~\n"

echo -e "\nCreating table 'teams'..."
echo "$($PSQL "\
  CREATE TABLE teams(\
    team_id SERIAL PRIMARY KEY,\
    name VARCHAR(30) UNIQUE NOT NULL
  );")"

echo -e "\nDisplaying 'teams' table details:"
echo "$($PSQL "\\d teams")"

echo -e "\n~~~~~~~~~~~~~~\n"

echo -e "\nCreating table 'games'..."
echo "$($PSQL "\
  CREATE TABLE games( \
    game_id SERIAL PRIMARY KEY, \
    year INT NOT NULL, \
    round VARCHAR(30) NOT NULL, \
    winner_goals INT NOT NULL, \
    opponent_goals INT NOT NULL, \
    winner_id INT NOT NULL, \
    opponent_id INT NOT NULL, \
    \
    FOREIGN KEY (winner_id) REFERENCES teams(team_id), \
    FOREIGN KEY (opponent_id) REFERENCES teams(team_id), \
    \
    CHECK(winner_id != opponent_id) \
  );")"

echo -e "\nDisplaying 'games' table details:"
echo "$($PSQL "\\d games")"

echo -e "\n~~~~~~~~~~~~~~\n"

function INSERT_TEAM {
  TEAM=$1
  TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$TEAM';")
  if [[ -z $TEAM_ID ]]; then # the team does not exist yet
    TEAM_INS=$($PSQL "INSERT INTO teams(name) VALUES('$TEAM');")
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$TEAM';")
  fi
  INSERT_TEAM_RESULT=$TEAM_ID
}

function INSERT_GAME {
  YEAR=$1; ROUND=$2; WG=$3; OG=$4; WID=$5; OID=$6
  GAME=$($PSQL " \
    INSERT INTO \
    games(year, round, winner_goals, opponent_goals, winner_id, opponent_id) \
    VALUES($YEAR, '$ROUND', $WG, $OG, $WID, $OID)")
}

while IFS="," read -r year round winner opponent winner_goals opponent_goals
do
  # insert winner team if it doesn't exist
  INSERT_TEAM "$winner"
  WINNER_ID=$INSERT_TEAM_RESULT
  echo "Winner id: $WINNER_ID"

  # insert opponent team if it doesn't exist
  INSERT_TEAM "$opponent"
  OPPONENT_ID=$INSERT_TEAM_RESULT
  echo "Opponent id: $OPPONENT_ID"

  echo -e "\nINSERT_GAME $year \"$round\" $winner_goals $opponent_goals '$winner:$WINNER_ID' '$opponent:$OPPONENT_ID'"
  INSERT_GAME $year "$round" $winner_goals $opponent_goals $WINNER_ID $OPPONENT_ID
done < <(tail -n +2 $CSV_FILE)

echo -e "\nThose are the teams:"
echo "$($PSQL "SELECT * FROM teams;")"

echo -e "\nThose are the games:"
echo "$($PSQL "SELECT * FROM games;")"

