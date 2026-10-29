#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z "$1" ]]; then
  echo "Please provide an element as an argument."
  exit 0
fi

ELEMENT=$($PSQL "
  SELECT
    elements.atomic_number,
    elements.symbol,
    elements.name,
    properties.atomic_mass,
    types.type,
    properties.melting_point_celsius,
    properties.boiling_point_celsius
  FROM elements
  INNER JOIN properties USING(atomic_number)
  INNER JOIN types USING(type_id)
  WHERE elements.atomic_number::TEXT = '$1'
     OR elements.symbol = '$1'
     OR elements.name = '$1';
")

if [[ -z "$ELEMENT" ]]; then
  echo "I could not find that element in the database."
  exit 0
fi

IFS='|' read -r ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS TYPE MELTING_POINT BOILING_POINT <<< "$ELEMENT"

echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."

exit 0
