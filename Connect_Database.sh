#!/bin/bash

# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}Enter Database name you want to connect: "
read DataBaseName

if [ ! -d "$DataBaseName" ]; then
    echo -e "${RED}Error: Database with the name '$DataBaseName' does not exist. Please choose the correct name.${NC}"

else
    cd "$DataBaseName" || exit

    source Table.sh

    # Check if the source command was successful
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Success: Table.sh sourced successfully.${NC}"
    else
        echo -e "${RED}Error: Unable to source Table.sh.${NC}"
    fi
fi
