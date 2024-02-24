#!/bin/bash
# If don't have any argument
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
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
fi