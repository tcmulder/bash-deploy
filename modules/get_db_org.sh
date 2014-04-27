#!/bin/sh

# #################################################################
# Get Database
# Dumps a database and saves it under a given file name
# #################################################################


# -----------------------------------------------------------------
# Output help info
# -----------------------------------------------------------------

# output help if requested
if [ $1 == 'help' ]; then
	echo "zen get db org ............... Download original database dump from remote server";
	exit;
fi

# -----------------------------------------------------------------
# Perform doctor diagnosis
# -----------------------------------------------------------------

# if diagnostics were requested
if [ $1 == 'doctor' ]; then
	# source the configuration file
	source $2;
	# tell the user the check is taking place
    big_echo "Checking remote \"$db_name\" Database";

    # copy the ssh password
    echo "$host_pass SSH password on clipboard";
    echo "$host_pass" | pbcopy;

	# connect to the remote database and list tables
    ssh_return=`ssh "$host_user"@"$host_name" "mysql -h$db_host -u$db_user -p$db_pass $db_name -e 'SHOW TABLES'"`;

    # if the list of tables is empty
    if [ ${#ssh_return} == 0 ]; then
    	# report failure
        alert_error 'Could not connect to database';
    # if the tables exist
    else
        # store the array of return data
        table_array=($ssh_return);
        # report number of tables found
        echo "tables recorded:  ${#table_array[@]}";
        # report success
        alert_success 'Connected to database'
    fi

	exit;
fi

# -----------------------------------------------------------------
# Get database
# -----------------------------------------------------------------

# source the configuration file
source $1;

# establish desired output filename
dir_for_dump="$dir_backup""org/db/"
file_dump="$dir_for_dump""org_db.sql";

# if the dump file doesn't already exist
if [ ! -f $file_dump ]; then

    #  if the backup directory exists
    if [ -d $dir_for_dump ]; then

        # copy ssh password to clipboard
        echo "$host_pass SSH password on clipboard";
        echo "$host_pass" | pbcopy;

        # download database dump
        ssh "$host_user"@"$host_name" "mysqldump -h$db_host -u$db_user -p$db_pass $db_name" | pv | cat - > $file_dump;

        # if the dump file now exists
        if [ -f $file_dump ]; then
            # show the size of the dumped file
            echo "Size of "$file_dump;
            du -ch $file_dump | grep total;
            # report success
            alert_success "Database file dumped";
        fi

    else
        # asdf
        alert_exit "Backup directory does not exist";

    fi

# if the dump file already exists
else
    # exit with error
    alert_exit "The dump file exist $file_dump";

fi

exit;