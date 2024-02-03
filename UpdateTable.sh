#!/usr/bin/bash

shopt -s extglob 

echo The tables are: 
ls -p | grep -v /


read -p "Enter the Table name that you want to update: " nameTable
 

echo "------------------------"
cat "$nameTable" | sed -e "s/:$/ /"

echo "====================================="

if [[ $nameTable = "" ]]; then
    echo "No value entered"
    exit 1
fi

if [ ! -f "$nameTable" ]; then
    echo "Table not found"
    exit 1
fi

read -p "Enter the column name you want to update in: " colName

if [[ $colName = "" ]]; then
    echo "No value entered"
    exit 1
fi
 if ! grep -q ":$colName:" "$nameTable"; then

    echo "Column not found"

    exit 1

fi
col=$(awk 'BEGIN{FS=":"}{if(NR==1){for(i=1;i<=NF;i++){if($i=="'$colName'") print i}}}' "$nameTable")

if [[ $col -eq 1 ]]; then
    echo "This is a primary key, and you can't update it"
    exit 1
fi

read -p "Enter the value in the column you want to update: " val

if [[ -z "$val" ]]; then
    echo "No value entered"
    exit 1
fi
 if ! grep -q ":$val:" "$nameTable"; then

    echo "value not found"

    exit 1
 fi

# Get data types for all columns from the third row
third_row=$(awk 'NR==3' "$nameTable")

IFS=':' read -ra datatypes <<< "$third_row"

# Check data type for the specified column
if [[ "${datatypes[$col-1]}" =~ [a-zA-Z] ]]; then
    if ! [[ "$val" =~ ^[a-zA-Z]+$ ]]; then
        echo "Error: Data type mismatch. The existing data is of type string."
        exit 1
    fi
elif [[ "${datatypes[$col-1]}" =~ ^[0-9]+$ ]]; then
    if ! [[ "$val" =~ ^[0-9]+$ ]]; then
        echo "Error: Data type mismatch. The existing data is of type integer."
        exit 1
    fi
else
    echo "Error: Unknown data type for the specified column."
    exit 1
fi

# Read the new value from the user
read -p "Enter the new value here: " val2

# Check data type for the new value
if [[ "${datatypes[$col-1]}" =~ [a-zA-Z] ]]; then
    if ! [[ "$val2" =~ ^[a-zA-Z]+$ ]]; then
        echo "Error: Data type mismatch. The new value must be of type string."
        exit 1
    fi
elif [[ "${datatypes[$col-1]}" =~ ^[0-9]+$ ]]; then
    if ! [[ "$val2" =~ ^[0-9]+$ ]]; then
        echo "Error: Data type mismatch. The new value must be of type integer."
        exit 1
    fi
else
    echo "Error: Unknown data type for the specified column."
    exit 1
fi

# Update the values in the specified rows
rowNums=$(awk -v col="$col" -v val="$val" -v nameTable="$nameTable" 'BEGIN{FS=":"}{if ($col==val && NR>=3) print NR}' "$nameTable")

for rowNum in $rowNums; do
    oldrecord=$(awk -v r="$rowNum" -v c="$col" 'BEGIN{FS=":"}{if(NR==r){print $c}}' "$nameTable")
    sed -i "${rowNum}s/$oldrecord/$val2/g" "$nameTable"
done

echo "Values updated successfully."

# Display the updated table
echo -e "\nUpdated Table:"
cat "$nameTable"
