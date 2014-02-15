#!/bin/sh

# #################################################################
# Get Code
# grabs code from a server and saves it under a given file name
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
root_remote=$1;
dir_remote=$2;
host_name=$3;
host_user=$4;
host_pass=$5;
dir_backup_version=$6;
version=$7;
dir_script=$8;

# -----------------------------------------------------------------
# Get Code
# -----------------------------------------------------------------

# if not asked for the stage code
if [ "$version" != "stage" ]; then

	# copy ssh password to clipboard
	echo "$host_pass SSH password on clipboard";
	echo "$host_pass" | pbcopy;

	# tar and download the code into backup directory
	ssh "$host_user"@"$host_name" "cd $root_remote/; tar -pzcf - $dir_remote;" | pv | cat - > "$dir_backup_version"/code/"$version"_code.tar.gz;

# if asked for the stage code
else

	# copy ssh password to clipboard
	echo "$host_pass SSH password on clipboard";
	echo "$host_pass" | pbcopy;

	# tar and download the code
	ssh "$host_user"@"$host_name" "cd $root_remote/; tar -pzcf - $dir_remote;" | pv | cat - > "$dir_backup_version"/../"$version"_code.tar.gz;

fi

exit;