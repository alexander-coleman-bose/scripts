#!/usr/bin/env bash
# Convert a database to an SQL script.
#
#   The script connects to an MSSQL database and generates a set of scripts
#   from it.
#
#   Run this script from inside this directory. If the following
#   variables aren't set in the environment or in .env, you will be prompted to
#   enter them:
#       SCRIPT_DB_SERVER - Server to connect to (i.e. usva-ceapprsch or localhost)
#       SCRIPT_DB_NAME - Database to script (i.e. Headphones or Headphones_Dev)
#       SCRIPT_DB_USERNAME - Username to connect to the server with
#       SCRIPT_DB_PASSWORD - Password for the above user
#
# Requirements:
#   python
#   mssql-scripter

# Alex St. Amour

# Set constants
this=script-db.sh
SCRIPTER_TABLE_ARGS=("--script-drop-create --include-types Schema Table --check-for-existence --target-server-version 2016 --target-server-edition Standard --display-progress")
SCRIPTER_OBJECT_ARGS=("--file-per-object --script-drop-create --exclude-types Database Schema Table --check-for-existence --target-server-version 2016 --target-server-edition Standard --display-progress")
SCRIPTER_DATA_ARGS=("--data-only --target-server-version 2016 --target-server-edition Standard --display-progress")
status_error=-1
status_okay=0

echo_help () {
    echo "Usage: $this [OPTIONS] ACTIONS..."
    echo ""
    echo "The script connects to an MSSQL database and generates a set of scripts from"
    echo "it."
    echo ""
    echo "Run this script from inside this directory. If the following"
    echo "variables aren't set in the environment or in .env, you will be prompted to"
    echo "enter them:"
    echo "  SCRIPT_DB_SERVER - Server to connect to (i.e. usva-ceapprsch or localhost)"
    echo "  SCRIPT_DB_NAME - Database to script (i.e. Headphones or Headphones_Dev)"
    echo "  SCRIPT_DB_USERNAME - Username to connect to the server with"
    echo "  SCRIPT_DB_PASSWORD - Password for the above user"
    echo ""
    echo "OPTIONS"
    echo "  -h|--help           Displays this help message"
    echo ""
    echo "ACTIONS"
    echo "  schema  - Script all database objects/schema"
    echo "  data    - Script the data from all database tables"
    echo ""
}

check_requirements() {
    # Check for mssql-scripter
    if [[ -z $(which mssql-scripter 2>/dev/null) ]]; then
        echo "$this:ERROR: mssql-scripter must be installed to run $this." >&2
        exit $status_error
    fi
}

check_variables () {
    # Get the variables by trying the environment, then .env, then user input, then error
    if [ -z "$SCRIPT_DB_SERVER" ]; then
        SCRIPT_DB_SERVER=$(grep 'SCRIPT_DB_SERVER' .env | awk -F= '{print $2}')
        if [ -z "$SCRIPT_DB_SERVER" ]; then
            read -rp "Enter the server to connect to: " SCRIPT_DB_SERVER
            echo ""
            if [ -z "$SCRIPT_DB_SERVER" ]; then
                echo "$this:ERROR: You must provide SCRIPT_DB_SERVER to run $this." >&2
                exit $status_error
            fi
        fi
    fi
    if [ -z "$SCRIPT_DB_NAME" ]; then
        SCRIPT_DB_NAME=$(grep 'SCRIPT_DB_NAME' .env | awk -F= '{print $2}')
        if [ -z "$SCRIPT_DB_NAME" ]; then
            read -rp "Enter the database on $SCRIPT_DB_SERVER to script from: " SCRIPT_DB_NAME
            echo ""
            if [ -z "$SCRIPT_DB_NAME" ]; then
                echo "$this:ERROR: You must provide SCRIPT_DB_NAME to run $this." >&2
                exit $status_error
            fi
        fi
    fi
    if [ -z "$SCRIPT_DB_USERNAME" ]; then
        SCRIPT_DB_USERNAME=$(grep 'SCRIPT_DB_USERNAME' .env | awk -F= '{print $2}')
        if [ -z "$SCRIPT_DB_USERNAME" ]; then
            read -rp "Enter the username to use for $SCRIPT_DB_SERVER:$SCRIPT_DB_NAME: " SCRIPT_DB_USERNAME
            echo ""
            if [ -z "$SCRIPT_DB_USERNAME" ]; then
                echo "$this:ERROR: You must provide SCRIPT_DB_USERNAME to run $this." >&2
                exit $status_error
            fi
        fi
    fi
    if [ -z "$SCRIPT_DB_PASSWORD" ]; then
        SCRIPT_DB_PASSWORD=$(grep 'SCRIPT_DB_PASSWORD' .env | awk -F= '{print $2}')
        if [ -z "$SCRIPT_DB_PASSWORD" ]; then
            read -srp "Enter the password for $SCRIPT_DB_USERNAME@$SCRIPT_DB_SERVER: " SCRIPT_DB_PASSWORD
            echo ""
            if [ -z "$SCRIPT_DB_PASSWORD" ]; then
                echo "$this:ERROR: You must provide SCRIPT_DB_PASSWORD to run $this." >&2
                exit $status_error
            fi
        fi
    fi
    MSSQL_SCRIPTER_PASSWORD="$SCRIPT_DB_PASSWORD"
    export MSSQL_SCRIPTER_PASSWORD
}

# Script the database init script (just use EOF)
script_database () {
    mkdir ./${SCRIPT_DB_NAME}
    thisFile="./${SCRIPT_DB_NAME}/${SCRIPT_DB_NAME}.Database.sql"
    gitIgnore="./${SCRIPT_DB_NAME}/.gitignore"
    echo "$this:INFO: Scripting $SCRIPT_DB_NAME to $thisFile..."
# Do not indent these lines, or that whitespace will be added to thisFile
cat << EOF > $thisFile
/****** Manual drop-create script for $SCRIPT_DB_NAME ******/
DROP DATABASE IF EXISTS [$SCRIPT_DB_NAME]
GO
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'$SCRIPT_DB_NAME')
BEGIN
CREATE DATABASE [$SCRIPT_DB_NAME]
END
GO
USE [$SCRIPT_DB_NAME]
GO
ALTER DATABASE [$SCRIPT_DB_NAME] SET  READ_WRITE
GO
EOF
cat << EOF > $gitIgnore
data
data.sql
EOF
}

script_schema () {
    # Script the database tables (uses MSSQL_SCRIPTER_PASSWORD internally)
    scripter_command="mssql-scripter -S $SCRIPT_DB_SERVER -d $SCRIPT_DB_NAME -U $SCRIPT_DB_USERNAME -f ./$SCRIPT_DB_NAME/$SCRIPT_DB_NAME.Tables.sql ${SCRIPTER_TABLE_ARGS[*]}"
    echo "$this:INFO:$scripter_command"
    if $scripter_command; then
        echo "" # warning: Target directory... doesn't include newline
        echo "$this:INFO: Scripted $SCRIPT_DB_SERVER:$SCRIPT_DB_NAME Schema/Tables to ./$SCRIPT_DB_NAME/$SCRIPT_DB_NAME.Tables.sql"
    else
        echo "$this:WARNING: mssql-scripter exited with a non-zero code."
        return $status_error
    fi
    # Script the other database objects (uses MSSQL_SCRIPTER_PASSWORD internally)
    scripter_command="mssql-scripter -S $SCRIPT_DB_SERVER -d $SCRIPT_DB_NAME -U $SCRIPT_DB_USERNAME -f ./$SCRIPT_DB_NAME ${SCRIPTER_OBJECT_ARGS[*]}"
    echo "$this:INFO:$scripter_command"
    if $scripter_command; then
        echo "" # warning: Target directory... doesn't include newline
        echo "$this:INFO: Scripted $SCRIPT_DB_SERVER:$SCRIPT_DB_NAME objects to ./$SCRIPT_DB_NAME/"
    else
        echo "$this:WARNING: mssql-scripter exited with a non-zero code."
        return $status_error
    fi
}

# Script the database data (uses MSSQL_SCRIPTER_PASSWORD internally)
script_data () {
    scripter_command="mssql-scripter -S $SCRIPT_DB_SERVER -d $SCRIPT_DB_NAME -U $SCRIPT_DB_USERNAME -f ./${SCRIPT_DB_NAME}/data.sql ${SCRIPTER_DATA_ARGS[*]}"
    echo "$this:INFO:$scripter_command"
    if $scripter_command; then
        echo "" # warning: Target directory... doesn't include newline
        echo "$this:INFO: Scripted $SCRIPT_DB_SERVER:$SCRIPT_DB_NAME to ./${SCRIPT_DB_NAME}/data.sql"
    else
        echo "$this:WARNING: mssql-scripter exited with a non-zero code."
    fi
}

################################################################################
# MAIN
################################################################################

# Handle inputs
if [[ $# -eq 0 ]]; then
    echo_help
    exit $status_okay
fi
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -h|--help)
            echo_help
            exit $status_okay
            ;;

        -*)
            echo "$this:ERROR: Unrecognized input $key. Stopping $this." >&2
            exit $status_error
            ;;

        *)
            actions+=("$key")
            shift
            ;;
    esac
done

# if [ -z "$actions" ]; then
#     actions+=("$default_action")
# fi

# Exit early if we don't have what we need to script databases
check_requirements
check_variables

# Print header
printf "%0.s*" {1..80} && echo ""
printf "* SCRIPT-DB.SH" && echo ""
printf "%0.s*" {1..80} && echo ""

# Script database
script_database

for action in "${actions[@]}"; do
    if [ "$action" == "schema" ]; then
        script_schema
    elif [ "$action" == "data" ]; then
        script_data
    else
        echo "$this:WARNING: '$action' is not a recognized action, skipping..." >&2
    fi
done

exit $status_okay
