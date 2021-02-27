#!/bin/bash
# This script runs the database setup script, so that when the DB Docker
# container is run, the setup script will be run.

# Source: https://cardano.github.io/blog/2017/11/15/mssql-docker-container

#!/bin/bash
db_hostname=localhost
user=sa
password=$SA_PASSWORD
wait_time=15s

# Wait for SQL Server to come up
echo "importing data will start in $wait_time..."
sleep $wait_time

echo ""
echo "================================================================================"
echo "$db_hostname:$SCRIPT_DB_NAME IMPORT"
echo "================================================================================"
echo ""

# Run the init scripts to create the DB, Schema, and Tables
#HACK(ALEX): Tables/Schema are in a single file, since I don't know how to handle foreign key constraint dependencies otherwise
echo "executing ./$SCRIPT_DB_NAME/$SCRIPT_DB_NAME.Database.sql"
/opt/mssql-tools/bin/sqlcmd -S "$db_hostname" -U "$user" -P "$password" -i ./$SCRIPT_DB_NAME/$SCRIPT_DB_NAME.Database.sql
echo "executing ./$SCRIPT_DB_NAME/$SCRIPT_DB_NAME.Tables.sql"
/opt/mssql-tools/bin/sqlcmd -S "$db_hostname" -U "$user" -P "$password" -i ./$SCRIPT_DB_NAME/$SCRIPT_DB_NAME.Tables.sql

# Create all the Roles
for entry in $SCRIPT_DB_NAME/*.Role.sql
do
    if [ -z $(echo "$entry" | grep "*") ]; then
        echo "executing $entry"
        /opt/mssql-tools/bin/sqlcmd -S "$db_hostname" -d "$SCRIPT_DB_NAME" -U "$user" -P "$password" -i "$entry"
    fi
done

#HACK(ALEX): Creating users is disabled because I don't know how to handle logins with users
# Create all the Users
# for entry in $SCRIPT_DB_NAME/*.User.sql
# do
#     if [ -z $(echo "$entry" | grep "*") ]; then
#         echo "executing $entry"
#         /opt/mssql-tools/bin/sqlcmd -S "$db_hostname" -d "$SCRIPT_DB_NAME" -U "$user" -P "$password" -i "$entry"
#     fi
# done

# Create all the Schema
for entry in $SCRIPT_DB_NAME/*.Schema.sql
do
    if [ -z $(echo "$entry" | grep "*") ]; then
        echo "executing $entry"
        /opt/mssql-tools/bin/sqlcmd -S "$db_hostname" -d "$SCRIPT_DB_NAME" -U "$user" -P "$password" -i "$entry"
    fi
done

# Create all the Tables
for entry in $SCRIPT_DB_NAME/*.Table.sql
do
    if [ -z $(echo "$entry" | grep "*") ]; then
        echo "executing $entry"
        /opt/mssql-tools/bin/sqlcmd -S "$db_hostname" -d "$SCRIPT_DB_NAME" -U "$user" -P "$password" -i "$entry"
    fi
done

# Create all the UserDefinedFunctions
for entry in $SCRIPT_DB_NAME/*.UserDefinedFunction.sql
do
    if [ -z $(echo "$entry" | grep "*") ]; then
        echo "executing $entry"
        /opt/mssql-tools/bin/sqlcmd -S "$db_hostname" -d "$SCRIPT_DB_NAME" -U "$user" -P "$password" -i "$entry"
    fi
done

# Create all the StoredProcedures
for entry in $SCRIPT_DB_NAME/*.StoredProcedure.sql
do
    if [ -z $(echo "$entry" | grep "*") ]; then
        echo "executing $entry"
        /opt/mssql-tools/bin/sqlcmd -S "$db_hostname" -d "$SCRIPT_DB_NAME" -U "$user" -P "$password" -i "$entry"
    fi
done

# Import any data
if [ -r ./$SCRIPT_DB_NAME/data.sql]; then
    echo ""
    echo "================================================================================"
    echo "IMPORTING DATA"
    echo "================================================================================"
    /opt/mssql-tools/bin/sqlcmd -S "$db_hostname" -d "$SCRIPT_DB_NAME" -U "$user" -P "$password" -i "./$SCRIPT_DB_NAME/data.sql"
fi

# # Import the data from the csv files
# for entry in data/*.csv
# do
#     # i.e: transform /data/MyTable.csv to MyTable
#     shortname=$(echo "$entry" | cut -f 1,2 -d '.' | cut -f 2 -d '/')
#     tableName="$SCRIPT_DB_NAME.$shortname"
#     echo "importing $tableName from $entry"
#     /opt/mssql-tools/bin/bcp "$tableName" in "$entry" -c -t',' -F 2 -S "$db_hostname" -d "$SCRIPT_DB_NAME" -U "$user" -P "$password" -e "bcp_$shortname.log"
# done

# Message ready
echo ""
echo "================================================================================"
echo "$db_hostname:$SCRIPT_DB_NAME ready!"
echo "================================================================================"

# Passthrough any commands to follow Docker conventions
exec "$@"
