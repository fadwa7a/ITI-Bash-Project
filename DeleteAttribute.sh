#!/bin/bash
clear
echo "Delete From Table:"
echo "----------------- "
read -p "Enter table name: " tableFile

# If user doesn't have directory for databases, create it
if [ ! -f "$tableFile" ]; then
    echo "Error! There is no table with that name."
elif [ -z "$tableFile" ]; then
    echo "Enter the name of the table you want to delete."
else
    cat "$tableFile"

    check=$(cat "$tableFile" | wc -l)

    Records=$(awk -F: 'END {print NR}' "$tableFile")
    counter=3

    # Check if this table contains data or not
    if [ "$Records" -eq 2 ]; then
        echo "There are no data recorded in this table"
    else
        # Getting the value of the primary key of the record that the user wants to delete
        while true; do
    echo "Please enter the primary key value of the record you want to delete"
    read PK

    # Assuming your primary keys are stored in an array called 'primaryKeys'
    primaryKeys=($(awk -F: 'NR > 2 {print $1}' "$tableFile"))

    found=false

    # Check if the entered value exists in the array of primary keys
    for existingPK in "${primaryKeys[@]}"; do
        if [ "$existingPK" == "$PK" ]; then
            found=true
            break
        fi
    done

    if [ "$found" == false ]; then
        echo "Please enter a valid primary key value"
    else
        break
    fi
done


        # Looping until finding that number of that primary key and delete this record
            awk -v PK="$PK" -F: '$1 != PK' "$tableFile" > "$tableFile.temp" && mv "$tableFile.temp" "$tableFile"


        # Check if this primary key exists or not
       
        check2=$(cat "$tableFile" | wc -l)
        if [ "$check" -gt "$check2" ]; then
            echo "Your record has been deleted successfully"
        else
            echo "This record doesn't exist"
        fi
    fi

    if [ ! "$Records" -eq 2 ]; then
        # Printing the table after the deleting operation
        echo "Your table after this operation becomes as follows:"
        cat "$tableFile"

    fi
fi
