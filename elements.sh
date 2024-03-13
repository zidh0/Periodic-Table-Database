#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table -t --tuples-only -c"

echo -e "\n\n~~Periodic Table~~\n\n"

if [[ -z $1 ]]
then
  echo -e "\nPlease provide an element as an argument."
  exit
fi

if [[ $1 =~ ^[1-9]+$ ]]
then
element=$($PSQL "SELECT atomic_number,name,symbol,type,atomic_mass,melting_point_celsius,boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number='$1'")
else
element=$($PSQL "SELECT atomic_number,name,symbol,type,atomic_mass,melting_point_celsius,boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE name='$1' OR symbol='$1'")
fi

if [[ -z $element ]]
then 
echo -e "\nI could not find that element in the database"
else
echo $element | while IFS=" |" read an name symbol type mass mp bp
do
  echo -e "\nThe element with atomic number $an is $name ($symbol). It's a $type, with a mass of $mass amu. $name has a melting point of $mp celsius and a boiling point of $bp celsius."
done
fi


