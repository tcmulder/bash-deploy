#!/bin/sh

# #################################################################
# Put Database
# puts the live_db.sql database live
# #################################################################

# -----------------------------------------------------------------
# Capture arguments
# -----------------------------------------------------------------
host_name=$1;
host_user=$2;
host_pass=$3;
db_host=$4;
db_user=$5;
db_pass=$6;
db_name=$7;
dir_script=$8;

# -----------------------------------------------------------------
# Put database
# -----------------------------------------------------------------

# copy ssh password to clipboard
echo "$host_pass SSH password on clipboard";
echo "$host_pass" | pbcopy;

# cat the database file and push it live
cat $dir_script/../live_db.sql | ssh "$host_user"@"$host_name" "cat - | mysql -h$db_host -u$db_user -p$db_pass $db_name";

exit;