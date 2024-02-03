#!/bin/bash
LC_COLLATE=C 
shopt -s extglob # turn on pattern and enable it

# Check for not empty name
read -p "Enter the Database Name: " DataBaseName
DataBaseName=$(echo "$DataBaseName" | tr ' ' '_')

# Remove spaces and replace with underscores
 
# Check for an empty name
if [[ -z "$DataBaseName" ]]; then
    echo "Validation failed: Please enter a non-empty name."
    exit
fi

# Check for a name starting with a number
if [[ "$DataBaseName" == [0-9]* ]]; then
    echo "Validation failed: Name cannot start with a number."
    exit
fi

# Check for spaces in the name
if [[ "$DataBaseName" != *[^[:space:]]* ]]; then
    echo "Validation failed: Name cannot consist of only spaces."
    exit
fi

# Check for the pattern: starts with a letter, followed by letters, numbers, or underscores
if ! [[ "$DataBaseName" =~ ^[a-zA-Z][a-zA-Z0-9_]*$ ]]; then
    echo "Validation failed: Please enter a valid name without spaces and not starting with a number."
    exit
fi

# Check if the database already exists
if [[ -d "$DataBaseName" ]]; then
    echo "Error: Database with the name '$DataBaseName' already exists. Please choose another name."
    exit
fi

# Create the database directory
mkdir -p "$DataBaseName"

echo "Database '$DataBaseName' was created successfully."
