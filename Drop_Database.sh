#!/bin/bash
LC_COLLATE=C 

shopt -s extglob #turn on pattern and enable it

read -p "Enter the Database Name: " DataBaseName

# Check for not empty name
DataBaseName=$(echo "$DataBaseName" | tr ' ' '_')

# Check for an empty name or a name starting with a number
if [[ -z $DataBaseName || $DataBaseName = [0-9]* || $DataBaseName = *" "+[a-zA-Z]* ]]; then
    echo "Validation failed: Please enter a valid name without spaces and not starting with a number."
    exit 
fi

# Check for at least one letter at the beginning
if ! [[ $DataBaseName =~ [a-zA-Z] ]]; then
    echo "Validation failed: Must contain at least one letter at the beginning."
  exit
fi
# Check for no special characters and numbers only allowed at the end
if ! [[ $DataBaseName =~ ^[a-zA-Z_]+[a-zA-Z0-9]*$ ]]; then
      echo "Validation failed: No special characters allowed, and numbers only allowed at the end."
exit
fi
 
# Check if the database already exists
if ! [[ -d $DataBaseName ]]; then
    echo "Error: Database with the name '$DataBaseName' already not exists. Please choose another name."
    exit
fi

# Create the database directory
rm -r "$DataBaseName"
echo "Database '$DataBaseName' was deleted successfully."
