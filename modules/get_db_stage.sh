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
    echo "zen get db stage ............. Download database dump from staging server";
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
    big_echo "Checking remote $db_stage_name Database";

    # copy the ssh password
    echo "$host_stage_pass SSH password on clipboard";
    echo "$host_stage_pass" | pbcopy;

    # connect to the remote database and list tables
    ssh_return=`ssh "$host_stage_user"@"$host_stage_name" "mysql -h$db_stage_host -u$db_stage_user -p$db_stage_pass $db_stage_name -e 'SHOW TABLES'"`;

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
        alert_success 'Connected to stage database'
    fi

    # connect to the local database and list tables
    ssh_return="`mysql -hlocalhost -uroot -proot -e 'SHOW DATABASES'`";

    # if the list of tables is empty
    if [ ${#ssh_return} == 0 ]; then
        # report failure
        alert_error 'Could not connect to local mysql server';
    # if the tables exist
    else
        # store the array of return data
        table_array=($ssh_return);
        # report number of tables found
        echo "databases recorded:  ${#table_array[@]}";
        # report success
        alert_success 'Connected to local mysql server'
    fi


    exit;
fi

# -----------------------------------------------------------------
# Get database
# -----------------------------------------------------------------

# source the configuration file
source $1;

# establish desired output filename
file_dump="$dir_backup""stage_db.sql";

# if the dump file doesn't already exist
if [ ! -f $file_dump ]; then

    #  if the backup directory exists
    if [ -d $dir_for_dump ]; then

        # copy ssh password to clipboard
        echo "$host_stage_pass SSH password on clipboard";
        echo "$host_stage_pass" | pbcopy;

        # download database dump
        ssh "$host_stage_user"@"$host_stage_name" "mysqldump -h$db_stage_host -u$db_stage_user -p$db_stage_pass $db_stage_name" | pv | cat - > $file_dump;

        # if the dump file now exists
        if [ -f $file_dump ]; then
            # show the size of the dumped file
            echo "Size of "$file_dump;
            du -ch $file_dump | grep total;
            # report success
            alert_success "Database file dumped";
        else
            alert_exit "The database was not successful dumped"
        fi

        # create temporary database
        temp_db="zen_script_"$((RANDOM%9000+1000))
        mysql -uroot -proot -e "CREATE DATABASE $temp_db;" || alert_exit "Unable to create the $temp_db database";

        # grab stage db
        mysql -uroot -proot $temp_db < "$dir_backup"stage_db.sql || alert_exit "Cannot import "$dir_backup"stage_db.sql";

        # replace url
        # function testfar() { php /Applications/MAMP/htdocs/_far.php "$1" root root localhost utf8 "$2" "$3" "$4"; }
        php /Applications/MAMP/htdocs/_far.php $temp_db root root localhost utf8 $url_stage $url || alert_exit 'Unable to conduct find and replace on database';
        # testfar $temp_db $stage_url $url;

        # dump the temporary database then drop it
        mysqldump -uroot -proot $temp_db > "$dir_backup"live_db.sql || alert_exit "Unable to dump database into "$dir_backup"live_db.sql";
        mysql -uroot -proot -e "DROP DATABASE $temp_db;"

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