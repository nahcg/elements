#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
elif [[ $1 =~ ^[0-9]+$ ]]
then
  ELEMENT_NUM=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING (atomic_number) INNER JOIN types USING (type_id) WHERE atomic_number= '$1'")
  if [[ -z $ELEMENT_NUM ]]
  then
    echo "I could not find that element in the database."
  else
    ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING (atomic_number) INNER JOIN types USING (type_id) WHERE atomic_number = '$1'")
    echo "$ELEMENT" | while IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MPC BPC
      do
    echo The element with atomic number "$ATOMIC_NUMBER" is "$NAME" \("$SYMBOL"\). It\'s a "$TYPE", with a mass of "$ATOMIC_MASS" amu. "$NAME" has a melting point of "$MPC" celsius and a boiling point of "$BPC" celsius.
    done
  fi
else [[ $1 =~ ^[a-Z]+$ ]]
  ELEMENT_STR=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING (atomic_number) INNER JOIN types USING (type_id) WHERE name = '$1' OR symbol = '$1'")
  if [[ -z $ELEMENT_STR ]]
  then
    echo "I could not find that element in the database."
  else
    ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING (atomic_number) INNER JOIN types USING (type_id) WHERE name = '$1' OR symbol = '$1'")
    echo "$ELEMENT" | while IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MPC BPC
      do
    echo The element with atomic number "$ATOMIC_NUMBER" is "$NAME" \("$SYMBOL"\). It\'s a "$TYPE", with a mass of "$ATOMIC_MASS" amu. "$NAME" has a melting point of "$MPC" celsius and a boiling point of "$BPC" celsius.
    done
  fi
fi