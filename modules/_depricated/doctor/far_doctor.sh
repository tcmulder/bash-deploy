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
    echo "zen far ...................... FAR URLs from stage_db.sql to live_db.sql";
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
    big_echo "Checking Database FAR";

    # connect to the local database and list tables
    mysql_return="`mysql -hlocalhost -uroot -proot -e 'SHOW DATABASES'`";

    # if the list of tables is empty
    if [ ${#mysql_return} == 0 ]; then
        # report failure
        alert_error 'Could not connect to local mysql server';
    # if the tables exist
    else
        # store the array of return data
        table_array=($mysql_return);
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
file_dump="$dir_backup""live_db.sql";

# if the dump file doesn't already exist
if [ ! -f $file_dump ]; then

    #  if the backup directory exists
    if [ -d $dir_for_dump ]; then

        # create temporary database
        temp_db="zen_script_"$((RANDOM%9000+1000))
        mysql -uroot -proot -e "CREATE DATABASE $temp_db;" || alert_exit "Unable to create the $temp_db database";

        # grab stage db
        mysql -uroot -proot $temp_db < "$dir_backup"stage_db.sql || alert_exit "Cannot import "$dir_backup"stage_db.sql";

        # replace url
        php /Applications/MAMP/htdocs/_far/srdb.cli.php -hlocalhost -uroot -proot -n"$temp_db" -s"$url_stage" -r"$url"

        php /Applications/MAMP/htdocs/_far.php $temp_db root root localhost utf8 $url_stage $url || alert_exit 'Unable to conduct find and replace on database';

        # dump the temporary database then drop it
        mysqldump -uroot -proot $temp_db > "$dir_backup"live_db.sql || alert_exit "Unable to dump database into "$dir_backup"live_db.sql";
        mysql -uroot -proot -e "DROP DATABASE $temp_db;"


        # if the dump file now exists
        if [ -f $file_dump ]; then
            # show the size of the dumped file
            echo "Size of "$file_dump;
            du -ch $file_dump | grep total;
            # report success
            alert_success "Database file dumped";
        # if the dump file does not exist
        else
            # report error
            alert_error "Database dump failed"

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