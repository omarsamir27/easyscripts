#!/usr/bin/env bash

# Reset
NC='\033[0m'       # Text Reset

# Regular Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White

# Underline
UBlack='\033[4;30m'       # Black
URed='\033[4;31m'         # Red
UGreen='\033[4;32m'       # Green
UYellow='\033[4;33m'      # Yellow
UBlue='\033[4;34m'        # Blue
UPurple='\033[4;35m'      # Purple
UCyan='\033[4;36m'        # Cyan
UWhite='\033[4;37m'       # White

# Background
On_Black='\033[40m'       # Black
On_Red='\033[41m'         # Red
On_Green='\033[42m'       # Green
On_Yellow='\033[43m'      # Yellow
On_Blue='\033[44m'        # Blue
On_Purple='\033[45m'      # Purple
On_Cyan='\033[46m'        # Cyan
On_White='\033[47m'       # White

# High Intensity
IBlack='\033[0;90m'       # Black
IRed='\033[0;91m'         # Red
IGreen='\033[0;92m'       # Green
IYellow='\033[0;93m'      # Yellow
IBlue='\033[0;94m'        # Blue
IPurple='\033[0;95m'      # Purple
ICyan='\033[0;96m'        # Cyan
IWhite='\033[0;97m'       # White

# Bold High Intensity
BIBlack='\033[1;90m'      # Black
BIRed='\033[1;91m'        # Red
BIGreen='\033[1;92m'      # Green
BIYellow='\033[1;93m'     # Yellow
BIBlue='\033[1;94m'       # Blue
BIPurple='\033[1;95m'     # Purple
BICyan='\033[1;96m'       # Cyan
BIWhite='\033[1;97m'      # White

# High Intensity backgrounds
On_IBlack='\033[0;100m'   # Black
On_IRed='\033[0;101m'     # Red
On_IGreen='\033[0;102m'   # Green
On_IYellow='\033[0;103m'  # Yellow
On_IBlue='\033[0;104m'    # Blue
On_IPurple='\033[0;105m'  # Purple
On_ICyan='\033[0;106m'    # Cyan
On_IWhite='\033[0;107m'   # White


if ! command -v psql 2>&1 >/dev/null
then
    echo -e "${Red}psql could not be found${NC}"
    exit 1
fi

if ! command -v pg_dump 2>&1 >/dev/null
then
    echo "psql could not be found"
    exit 1
fi

# get the source database server address and port without color
echo -n -e "Enter the ${BIWhite}SOURCE${NC} database server address:"
read -p "" source_db_server

echo -n -e "Enter the ${BIWhite}SOURCE${NC} database server port:"
read -p "" source_db_port

echo -n -e "Enter the ${BIWhite}SOURCE${NC} database name:"
read -p "" source_db_name

echo -n -e "Enter the ${BIWhite}SOURCE${NC} database user:"
read -p "" source_db_user


echo "----------------------------------------------------"

#get the destination database server address and port without color

echo -n -e "Enter the ${BIWhite}DESTINATION${NC} database server address:"
read -p "" destination_db_server

echo -n -e "Enter the ${BIWhite}DESTINATION${NC} database server port:"
read -p "" destination_db_port

echo -n -e "Enter the ${BIWhite}DESTINATION${NC} database name:"
read -p "" destination_db_name

echo -n -e "Enter the ${BIWhite}DESTINATION${NC} database user:"
read -p "" destination_db_user

echo "Backing up the source database"

echo "Enter the password for the source database user"

SOURCE_DATABASE_STRING="${source_db_server}:${source_db_port}_${source_db_name}"

SOURCE_BACKUP_FILE="${SOURCE_DATABASE_STRING}_$(date --iso-8601=seconds).sql"

pg_dump --clean -h "$source_db_server" -p "$source_db_port" -U "$source_db_user" "$source_db_name" > ./"$SOURCE_BACKUP_FILE"

echo "Backup file created: $SOURCE_BACKUP_FILE"

echo "Backing up the destination database"

echo "Enter the password for the destination database user"

DESTINATION_DATABASE_STRING="${destination_db_server}:${destination_db_port}_${destination_db_name}"

DESTINATION_BACKUP_FILE="${DESTINATION_DATABASE_STRING}_$(date --iso-8601=seconds).sql"

pg_dump --clean -h "$destination_db_server" -p "$destination_db_port" -U "$destination_db_user" "$destination_db_name" > ./"$DESTINATION_BACKUP_FILE"

echo "Backup file created: $DESTINATION_BACKUP_FILE"

echo "Restoring the source database to the destination database"

psql -h "$destination_db_server" -p "$destination_db_port" -U "$destination_db_user" -d "$destination_db_name" -f "$SOURCE_BACKUP_FILE"

echo -e "${BIGreen}Restoration complete${NC}"

