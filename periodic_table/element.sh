#!/bin/bash

# Checking if any argument was given
if [[ -z $1 ]]; then
  # if there's no argument ask for it
  echo 'Please provide an element as an argument.'
else
  # if there's an argument
  TYPE=''
  # check if it's an atomic number
  if [[ $1 =~ ^[0-9]+$ ]]; then
    TYPE='atomic'
  # else check if it's a symbol
  elif [[ $1 =~ ^[A-Z][a-z]?$ ]]; then
    TYPE='symbol'
  # else check if it's a name
  elif [[ $1 =~ ^[a-zA-Z]+$ ]]; then
    TYPE='name'
  fi

  FULL_TABLE="( \
    SELECT \
    atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type \
    FROM
      elements INNER JOIN properties USING (atomic_number)
      INNER JOIN types USING (type_id) \
    ) AS ft"

  QUERY=''
  if [[ $TYPE == 'atomic' ]]; then
    QUERY="SELECT * FROM $FULL_TABLE WHERE atomic_number = $1"
  elif [[ $TYPE == 'symbol' ]]; then
    QUERY="SELECT * FROM $FULL_TABLE WHERE symbol = '$1'"
  elif [[ $TYPE == 'name' ]]; then
    QUERY="SELECT * FROM $FULL_TABLE WHERE name = '$1'"
  fi

  PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

  ELEMENT_DATA="$($PSQL "$QUERY")"

  if [[ -z $ELEMENT_DATA ]]; then
    echo "I could not find that element in the database."
  else
    echo $ELEMENT_DATA | sed 's/|/ /g' | while read ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE; do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi
fi