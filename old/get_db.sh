#!/bin/sh

# #################################################################
# Get Database
# dumps a database and saves it under a given file name
# #################################################################

# -----------------------------------------------------------------
# Handle Errors
# -----------------------------------------------------------------
function error_exit(){
    echo "* error: $1";
    exit
}

# -----------------------------------------------------------------
# Capture Arguments
# -----------------------------------------------------------------
dir_backup_version=$1;
host_name=$2;
host_user=$3;
host_pass=$4;
db_host=$5;
db_user=$6;
db_pass=$7;
db_name=$8;
version=$9;
dir_script=${10};

# -----------------------------------------------------------------
# Get Database
# -----------------------------------------------------------------

# if not asked for the stage database
if [ "$version" != "stage" ]; then

	# copy ssh password to clipboard
	echo "$host_pass SSH password on clipboard";
	echo "$host_pass" | pbcopy;

	# download database dump into backup directory
	ssh "$host_user"@"$host_name" "mysqldump -h$db_host -u$db_user -p$db_pass $db_name" | pv | cat - > "$dir_backup_version"db/"$version"_db.sql;

# if asked for the stage database
else

	# copy ssh password to clipboard
	echo "$host_pass SSH password on clipboard";
	echo "$host_pass" | pbcopy;

	# download database dump
	ssh "$host_user"@"$host_name" "mysqldump -h$db_host -u$db_user -p$db_pass $db_name" | pv | cat - > $dir_script/../"$version"_db.sql;

fi

exit;