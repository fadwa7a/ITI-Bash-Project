clear
#! /usr/bin/bash

# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}WELCOME INTO DataBase"
echo "====================================="

while true; do
  PS3="Please Choose one of  choises : "
space=" "
select  var in CreateTB InsertTB ListTB UptadeTB DropTB DeleteAttribute Main_Menu Exit
do
	case $var in
		CreateTB )	
		.	CreatTable.sh
        ;;
		InsertTB )
	    . InsertTable.sh
		
		;;
		ListTB )
	      . listTable.sh
		;;
		UptadeTB ) 
		    . UpdateTable.sh
		;;

		DropTB )
			 . DropTable.sh	 
		;;
		
		 
		DeleteAttribute )
		   . DeleteAttribute.sh
		 ;;
		Exit )
		   exit
		;;
		
	 
		Main_Menu )
		.   main.sh
	
		;;

		* ) 
		     echo -e "${RED}Wrong choice, Please enter a valid option";
		     exit
		;;
	esac

 if [ -n "$var" ]; then
    break
  fi

done

done
