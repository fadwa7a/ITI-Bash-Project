#! /usr/bin/bash
echo "WELCOME INTO OUR APP"
echo "====================================="

while true; do
  PS3="Please Choose one of  choises : "

select var in CreateDB ListDB  ConnectDB DropDB Exit
do
	case $var in
		CreateDB )	
		.	 Create_Database.sh
		;;
		ListDB )
		.	List_Database.sh
		;;
		ConnectDB ) 
		.        Connect_Database.sh
		;;

		DropDB )
		.	 Drop_Database.sh	 
		;;
		 
		Exit )
		   exit
		;;
		* ) 
		     echo "Wrong choice, Please enter one of the option";
		    
		;;
	esac

break

done
done


