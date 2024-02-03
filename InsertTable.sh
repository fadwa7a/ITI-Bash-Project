#!/bin/bash
clear
export LC_COLLATE=C

# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
BROWN='\033[0;33m'
NC='\033[0m' # No Color

validateData() {
    local datacon="$1"
    local data_type="$2"

    if [[ "$data_type" == "int" ]]; then
        if [[ -n "$datacon" && "$datacon" =~ ^[0-9]+$ ]]; then
            return 0  # Success
        else
            echo -e "${RED}Error! Data must be an integer and cannot be empty. Please try again.${NC}"
            return 1  # Failure
        fi
    elif [[ "$data_type" == "string" ]]; then
        if [[ -n "$datacon" && "$datacon" =~ ^[a-zA-Z][a-zA-Z0-9]*$ ]]; then
            return 0  # Success
        else
            echo -e "${RED}Error! Data must be an alphanumeric string and cannot be empty. Please try again.${NC}"
            return 1  # Failure
        fi
    else
        echo -e "${RED}Error! Unknown data type: $data_type.${NC}"
        return 1  # Failure
    fi
}

readData() {
    local column_number="$1"
    local data_type="$2"
    local datacon

    while true; do
        read -p "$(echo -e "${BLUE}Enter data of row for column $column_number ($data_type): ${NC}")" datacon

        if [[ -n "$datacon" ]]; then
            validateData "$datacon" "$data_type" || return 1
            echo "$datacon"
            break
        else
            echo -e "${RED}Error! Invalid or empty data. Please try again.${NC}"
        fi
    done
}

read -p "$(echo -e "${BLUE}Enter table name: ${NC}")" tableFile

echo -e "${BROWN}------------------------${NC}"
    cat "$tableFile" | sed -e "s/:$/ /"

echo -e "${BROWN}=====================================${NC}"

if [ ! -f "$tableFile" ]; then
    echo -e "${RED}Error! There is no table with that name.${NC}"
elif [ -z "$tableFile" ]; then
    echo -e "${RED}Enter the name of the table you want to insert into.${NC}"
else
    first_column_data=($(awk -F: 'NR > 1 {print $1}' "$tableFile"))

    datatype=($(awk -F: 'NR==2 {for(i=1;i<=NF;i++) print $i}' "$tableFile"))

    value=""

   # ... (previous code)

for ((i=0; i<${#datatype[@]}; i++)); do
    data=${datatype[i]}
    if [ $i -eq 0 ]; then
        if [[ "$data" == "int" ]]; then
            datacon=$(readData "$((i+1))" "$data")

            if [[ -z "$datacon" ]]; then
                echo -e "${RED}Error! Data for column $((i+1)) must be an integer and cannot be empty. Please try again.${NC}"
                return 1
            fi

            if [[ ! "$datacon" =~ ^[0-9]+$ ]]; then
                echo -e "${RED}Error! Data for column $((i+1)) must be an integer. Please try again.${NC}"
                return 1
            fi

            if [[ " ${first_column_data[@]} " =~ " ${datacon} " ]]; then
                echo -e "${RED}Error! Primary key already exists. Please try again.${NC}"
                return 1
            else
                value=$value$datacon":"
                first_column_data+=("$datacon")
            fi
        elif [[ "$data" == "string" ]]; then
            datacon=$(readData "$((i+1))" "$data")

            if [[ -z "$datacon" ]]; then
                echo -e "${RED}Error! Data for column $((i+1)) must be a string and cannot be empty. Please try again.${NC}"
                return 1
            fi

            validateData "$datacon" "$data" || return 1
            value=$value$datacon":"
            first_column_data+=("$datacon")
        else
            echo -e "${RED}Error! Unknown data type for the first column: $data.${NC}"
            return 1
        fi
    else
        datacon=$(readData "$((i+1))" "$data")
        validateData "$datacon" "$data" || return 1
        value=$value$datacon":"
    fi
done


    echo $value >> "$tableFile"
    echo -e "${GREEN}Record was added to the table successfully.${NC}"
    echo -e "${BROWN}=====================================${NC}"
    echo -e "${BROWN}$tableFile =============${NC}"

    cat "$tableFile" | sed -e "s/:$/ /"
    echo -e "${BROWN}=====================================${NC}"
fi
