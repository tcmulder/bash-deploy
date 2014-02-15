#!/bin/sh

# #################################################################
# Drop Database
# drops all tables in the live database
# #################################################################

# -----------------------------------------------------------------
# Capture Arguments
# -----------------------------------------------------------------
host_name=$1
host_user=$2
host_pass=$3
db_host=$4
db_user=$5
db_pass=$6
db_name=$7

# -----------------------------------------------------------------
# Drop Database
# -----------------------------------------------------------------

# copy ssh password
echo "$host_pass SSH password on clipboard";
echo "$host_pass" | pbcopy;

# drop the database
ssh "$host_user"@"$host_name" "mysqldump -h$db_host -u$db_user -p$db_pass $db_name | grep ^DROP | mysql -h$db_host -u$db_user -p$db_pass $db_name";

exit;