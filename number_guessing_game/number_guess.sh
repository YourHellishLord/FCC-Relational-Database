#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

### FUNCTIONS - start ###

function GET_USER_ID {
  USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")
}

function GET_USER_DATA {
  GET_USER_ID
  USER_DATA=$($PSQL "\
    SELECT COUNT(attempts), MIN(attempts) FROM \
    users INNER JOIN games USING (user_id) \
    WHERE user_id=$USER_ID \
  ")
}

function INSERT_USER {
  INSERT_USER_RESULT=$($PSQL "INSERT INTO users(username) VALUES ('$USERNAME')")
  
  if [[ $INSERT_USER_RESULT != "INSERT 0 1" ]]; then
    echo "Error: unable to create user with username '$USERNAME'."
    exit
  fi

  GET_USER_ID
}

function INSERT_GAME {
  GET_USER_ID

  INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(user_id, attempts) VALUES ($USER_ID, $NUMBER_OF_GUESSES)")
  
  if [[ $INSERT_GAME_RESULT != "INSERT 0 1" ]]; then
    echo "Error: unable to create game."
    exit
  fi
}

### FUNCTIONS - end ###

SECRET_NUMBER=$(( ($RANDOM % 1000) + 1 ))
echo -e "Enter your username:"
read USERNAME
echo $SECRET_NUMBER

if [[ ${#USERNAME} -gt 22 ]]; then
  echo -e "Username must be max 22 characters long."
  exit
fi

GET_USER_ID

if [[ -z $USER_ID ]]; then
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  INSERT_USER
else
  GET_USER_DATA
  echo $USER_DATA | sed 's/|/ /g' | while read GAMES_PLAYED BEST_GAME; do
    echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  done
fi

echo "Guess the secret number between 1 and 1000:"

NUMBER_OF_GUESSES=0
while [[ $USER_GUESS != $SECRET_NUMBER ]]; do
  read USER_GUESS
  NUMBER_OF_GUESSES=$(($NUMBER_OF_GUESSES + 1))
  if [[ ! $USER_GUESS =~ ^[0-9]+$ ]]; then
    echo "That is not an integer, guess again:"
  elif [[ $USER_GUESS -gt $SECRET_NUMBER ]]; then
    echo -e "It's higher than that, guess again:"
  elif [[ $USER_GUESS -lt $SECRET_NUMBER ]]; then
    echo -e "It's lower than that, guess again:"
  fi
done

INSERT_GAME
echo "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"

