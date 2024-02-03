   #!/usr/bin/bash

shopt -s extglob

cleanName() {
    local var="$*"
    var=$(echo "$var" | tr -s ' ' | tr ' ' '_')
    echo -n "$var"
}

create_table() {
    local tableName=$1
    local colCount=0
    local colIndex=1
    local colNames=""
    local colTypes=""
    local colType=0

     while [ $colCount -lt $2 ]; do
    read -p "Enter the name of column number $colIndex: " colName
    col_name=$(cleanName "$col_Name")
    if [[ $colName =~ [^a-zA-Z_] || $colName == [0-9]* ]]; then
        echo "Invalid column name. Please enter a valid name without spaces, special characters, and not starting with a number."
        continue
    fi

    if [ "$colName" ]; then
        read -p "Enter the Type of column 'int' or 'string': " colType

        if [ "$colType" = "" ]; then
            echo "No value entered. Please enter the type of column."
            continue
        elif [[ $colType == "string" || $colType == "int" ]]; then
            if [[ $colCount == 0 ]]; then
                colNames=$colName":"
                colTypes=$colType":"
            else
                colNames=$colNames$colName":"
                colTypes=$colTypes$colType":"
            fi
        else
            echo "Unknown Data Type. Please enter a valid column type."
            continue
        fi
    else
        echo "No data entered. Please enter the column name."
        continue
    fi

    ((colCount++))
    ((colIndex++))
done

    if [[ colCount -lt $2 ]]; then
        echo "Table creation failed. Please try again."
        return 1
    else
         echo -e "$colNames\n$colTypes" > "$tableName"
        echo "Table '$tableName' created successfully"
        echo "============================="
        echo " Table '$tableName' Content : "
        echo "============================="
        cat "$tableName"
   fi
}

read -p "Enter the Table name:  " tableName
tableName=$(cleanName "$tableName")
if [[ $tableName = "" ]]; then
    echo " Error : You didn't enter any value."
    exit 1
elif [ ! -f "$tableName" ]; then
    if [[ $tableName =~ [^a-zA-Z_] ]]; then
        echo "Error table name: Please enter a valid name without special characters, and not starting with a number."
        exit 1
     
        read -p "Enter the number of columns: " col

        if [[ $col = "" ]]; then
            echo "You didn't enter any value. Please enter the number of columns."
            exit 1
        fi

        create_table "$tableName" "$col"

    else
        echo "Incorrect Table name. Please enter a valid table name."
        exit 1
    fi
else
    echo "Table Already Exists."
    exit 1
fi

