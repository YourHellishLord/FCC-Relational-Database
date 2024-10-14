#! /bin/bash

if [[ $1 == "test" ]]
then
  DB_NAME="worldcuptest"

else
  DB_NAME="worldcup"
fi

PSQL="psql --username=postgres --dbname=$DB_NAME --no-align --tuples-only -c"


# Do not change code above this line. Use the PSQL variable above to query your database.

echo -e "\nTotal number of goals in all games from winning teams:"
echo "$($PSQL "SELECT SUM(winner_goals) FROM games")"

echo -e "\nTotal number of goals in all games from both teams combined:"
echo "$($PSQL "SELECT (SUM(winner_goals)+SUM(opponent_goals)) as total_goals FROM games")"

echo -e "\nAverage number of goals in all games from the winning teams:"
echo "$($PSQL "SELECT AVG(winner_goals) FROM games")"

echo -e "\nAverage number of goals in all games from the winning teams rounded to two decimal places:"
echo "$($PSQL "SELECT ROUND(AVG(winner_goals), 2) FROM games")"

echo -e "\nAverage number of goals in all games from both teams:"
echo "$($PSQL "SELECT ROUND(AVG(winner_goals) + AVG(opponent_goals), 16) FROM games")"

echo -e "\nMost goals scored in a single game by one team:"
echo "$($PSQL "SELECT MAX(winner_goals) FROM games")"

echo -e "\nNumber of games where the winning team scored more than two goals:"
echo "$($PSQL "SELECT count(winner_goals) FROM games WHERE winner_goals > 2")"

echo -e "\nWinner of the 2018 tournament team name:"
echo "$($PSQL "SELECT name FROM teams INNER JOIN games ON games.winner_id = teams.team_id WHERE year=2018 AND round='Final';")"

echo -e "\nList of teams who played in the 2014 'Eighth-Final' round:"
echo "$($PSQL " \
    SELECT name FROM ( \
      SELECT T1.name FROM games \
        INNER JOIN teams T1 ON games.winner_id = T1.team_id \
        WHERE games.year = 2014 AND games.round = 'Eighth-Final' \
      UNION
      SELECT T2.name FROM games \
        INNER JOIN teams T2 ON games.opponent_id = T2.team_id \
        WHERE games.year = 2014 AND games.round = 'Eighth-Final' \
    ) AS my_union ORDER BY name ASC;" \
  )"

echo -e "\nList of unique winning team names in the whole data set:"
echo "$($PSQL " \
      SELECT DISTINCT name \
        FROM teams \
        INNER JOIN games ON teams.team_id = games.winner_id \
        ORDER BY name ASC" \
      )"

echo -e "\nYear and team name of all the champions:"
echo "$($PSQL " \
    SELECT year, name \
      FROM teams \
      INNER JOIN games ON teams.team_id = games.winner_id \
      WHERE round = 'Final' \
      ORDER BY year ASC" \
    )"

echo -e "\nList of teams that start with 'Co':"
echo "$($PSQL " \
        SELECT name \
          FROM teams \
          WHERE name LIKE 'Co%'" \
      )"


