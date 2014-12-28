#!/bin/bash

# #################################################################
# Get Database
# -----------------------------------------------------------------
# description: dumps a database and saves it under a given file name
# since version: 3.0
# #################################################################


# -----------------------------------------------------------------
# Output help info
# -----------------------------------------------------------------

# output help if requested
if [ $1 == 'help' ]; then
    echo "zen put db ................... Drop live database and upload live_db.sql";
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
    ssh_return=`ssh "$host_user"@"$host_name" "mysql -h'$db_host' -u'$db_user' -p'$db_pass' '$db_name' -e 'SHOW TABLES'"`;

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
file_dump="$dir_backup"live_db.sql;

# if the dump file exists for upload
if [ -f $file_dump ]; then

    # tell the user we're dropping tables
    echo "Dropping tables on remote database";

    # copy ssh password
    echo "$host_pass SSH password on clipboard";
    echo "$host_pass" | pbcopy;

    # drop the database
    ssh "$host_user"@"$host_name" "mysqldump -h'$db_host' -u'$db_user' -p'$db_pass' '$db_name' | grep ^DROP | mysql -h'$db_host' -u'$db_user' -p'$db_pass' '$db_name'";

    # tell the user we're uploading the database
    echo "Uploading live_db.sql to remote database";

    # copy ssh password to clipboard
    echo "$host_pass SSH password on clipboard";
    echo "$host_pass" | pbcopy;

    # cat the database file and push it live
    cat $file_dump | ssh "$host_user"@"$host_name" "cat - | mysql -h'$db_host' -u'$db_user' -p'$db_pass' '$db_name'";

    # tell the user we're checking the url
    echo "Checking siteurl for uploaded database";

    # copy ssh password
    echo "$host_pass SSH password on clipboard";
    echo "$host_pass" | pbcopy;

    # get the siteurl value
    option_value=`ssh "$host_user"@"$host_name" "mysql -h'$db_host' -u'$db_user' -p'$db_pass' '$db_name' -e 'SELECT option_value FROM "$db_table_prefix"options WHERE option_name=\"siteurl\"'"`;
    option_value_array=($option_value);
    siteurl=${option_value_array[1]};

    # if the siteurl matches the requested one
    if [ "$siteurl" == "$url" ]; then
        # report success
        alert_success "$siteurl value reported as the url";
    # if the siteurl does not match what was requested
    else
        # report actual values
        echo "url provided:                 $url";
        echo "value reported as siteurl:    $siteurl";
        # report failure and exit
        alert_exit 'Database cell "siteurl" and url provided do not match'
    fi

# if the dump file doesn't exist for upload
else

    # report error
    alert_exit "The dump file does not exist $file_dump";

fi

exit;
