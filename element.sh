#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"


if [[ -z $1 ]]; then
  # no argument provided
  echo "Please provide an element as an argument."
elif [[ $1 =~ ^[0-9]+$ ]]; then
  # argument is a number
  ATOMIC_RESULT=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1")
  if [[ -n $ATOMIC_RESULT ]]; then
    # find element info
    ELEMENT_RESULT=$($PSQL "SELECT e.atomic_number, e.symbol, e.name, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius, t.type FROM elements e INNER JOIN properties p ON e.atomic_number = p.atomic_number INNER JOIN types t ON p.type_id = t.type_id WHERE e.atomic_number='$ATOMIC_RESULT'")
    echo "$ELEMENT_RESULT" | while IFS='|' read ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS TYPE
    do
      # print requested info
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
    done
  else
    # no element with this atomic number
    echo "I could not find that element in the database."
  fi
else
  # argument provided, not a number, check if name
  NAME_RESULT=$($PSQL "SELECT name FROM elements WHERE name='$1'")
  if [[ -n $NAME_RESULT ]]; then
    # find element info
    ELEMENT_RESULT=$($PSQL "SELECT e.atomic_number, e.symbol, e.name, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius, t.type FROM elements e INNER JOIN properties p ON e.atomic_number = p.atomic_number INNER JOIN types t ON p.type_id = t.type_id WHERE e.name='$NAME_RESULT'")
    echo "$ELEMENT_RESULT" | while IFS='|' read ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS TYPE
    do
      # print requested info
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
    done
  else
    # check if symbol
    SYMBOL_RESULT=$($PSQL "SELECT symbol FROM elements WHERE symbol='$1'")
    if [[ -n $SYMBOL_RESULT ]]; then
      # find element info
      ELEMENT_RESULT=$($PSQL "SELECT e.atomic_number, e.symbol, e.name, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius, t.type FROM elements e INNER JOIN properties p ON e.atomic_number = p.atomic_number INNER JOIN types t ON p.type_id = t.type_id WHERE e.symbol='$SYMBOL_RESULT'")
      echo "$ELEMENT_RESULT" | while IFS='|' read ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS TYPE
    do
      # print requested info
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
    done
    fi
  fi
  # No valid argument provided
  if [[ -z $NAME_RESULT && -z $SYMBOL_RESULT ]]; then
    echo "I could not find that element in the database."
  fi
fi
