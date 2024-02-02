 #!/user/bin/bash
 shopt -s extglob #turn on pattern and enable it
 
 #Function to check if a string starts or ends with a space
  cleanName() {
    local var="$*"
    var=$(echo "$var" | tr -s ' ' | tr ' ' '_')
    echo -n "$var"
}
read -p "Enter the name of the table: " tableName

 tableName=$(cleanName "$tableName")
 
# Check if the user didn't enter any data for the table name
if [ -z "$tableName" ]; then
    echo "Error: No name entered. Please enter a valid name."
    exit 1
fi
# Check for a valid table name
 if [[ $tableName =~ [^a-zA-Z_] || $tableName =~ ^[0-9] ]]; then
    echo "Error table name: Please enter a valid name without special characters, and not starting with a number."
    exit 1
 fi
 
 # Check if the table file already exists
tableFile="$tableName.txt"
if [ -f "$tableFile" ]; then
    echo "Error: Table name '$tableFile' already exists. Please choose another name."
    exit 1
fi
# Assuming col_defs is the array containing column names and types
col_defs=()

read -p "Enter the number of columns: " num_cols

for ((i = 1; i <= num_cols; i++)); do
    read -p "Enter the name of column $i: " col_name
     col_name=$(cleanName "$col_name")
     if [[ -z $col_name || $col_name =~ [^a-zA-Z_] || $tableName =~ ^[0-9]  ]]; then
        echo "Invalid column name. Please enter a valid name without spaces , special characters and not starting with a number."
        exit 1
    fi

    read -p "Enter the type of column $i (int/string): " type

 
    if [[ $type != "int" && $type != "string" ]]; then
        echo "Invalid column type. Please enter 'int' or 'string'."
        exit 1
    fi

 # Set primary key status for the first column
    if [[ $i -eq 1 ]]; then
        isPrimaryKey="PRIMARY KEY"
    else
        isPrimaryKey=""
    fi

    col_defs[$i]="$col_name $type $isPrimaryKey"
done

 
tableFile="$tableName.txt"


# Write the table definition to the file
echo "Table: $tableName" > "$tableFile"
for ((i = 1; i <= num_cols; i++)); do
    echo "${col_defs[$i]}" >> "$tableFile"
done

echo "Table '$tableName' created successfully. Definition stored in '$tableFile'."

echo " Table '$tableName' Content : "
echo "----------------------------------"
for ((i = 1; i <= num_cols; i++)); do
    echo "Column $i: ${col_defs[$i]}"
done




