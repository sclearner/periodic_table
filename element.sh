#!/bin/bash
# If don't have any argument
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  PSQL="psql --username=freecodecamp --dbname=periodic_table -t -c"
  # columns need to get
  COLUMNS="atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius"
  # check atomic number
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    RESULT=$($PSQL "SELECT $COLUMNS FROM elements inner join properties using(atomic_number) inner join types using(type_id) where atomic_number=$1")
  else
    RESULT=$($PSQL "SELECT $COLUMNS FROM elements inner join properties using(atomic_number) inner join types using(type_id) where name='$1'")
    if [[ -z $RESULT ]]
    then
      RESULT=$($PSQL "SELECT $COLUMNS FROM elements inner join properties using(atomic_number) inner join types using(type_id) where symbol='$1'")  
    fi
  fi
  # return result
  if [[ $RESULT ]]
  then
    echo $RESULT | while read atomic_number bar name bar symbol bar type bar atomic_mass bar melting_point_celsius bar boiling_point_celsius
    do
      echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_point_celsius celsius and a boiling point of $boiling_point_celsius celsius."
    done
  else
    echo "I could not find that element in the database."
  fi
fi