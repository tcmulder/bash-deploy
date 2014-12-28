#!/bin/bash

# #################################################################
# Get Database
# -----------------------------------------------------------------
# description: dumps a database and saves it under a given file name
# since version: 4.0
# #################################################################

# module function
function module(){

    # source the configuration file
    source "$config_file";

    # establish desired output filename
    origin_directory="$dir_backup$origin_name""/db/";
    to_launch="$origin_directory""launch_db.sql";

    # if the dump file exists for upload
    if [ -f $to_launch ]; then

        # ask whether or not to proceed
        read -p "Drop live database tables and import new? [yes|NO] " confirm;
        confirm=${confirm:-no};
        # if the answer is yes
        if [ "$confirm" != 'yes' ]; then
            # exit with error
            alert_exit "Database not launched";
        fi

        # tell the user we're dropping tables
        echo "Dropping tables on remote database";

        # copy ssh password
        echo "$(ar $server_arr 'host_pass') SSH password on clipboard";
        echo "$(ar $server_arr 'host_pass')" | pbcopy;

        # drop the database
        ssh "$(ar $server_arr 'host_user')"@"$(ar $server_arr 'host_name')" "mysqldump -h'$(ar $server_arr 'db_host')' -u'$(ar $server_arr 'db_user')' -p'$(ar $server_arr 'db_pass')' '$(ar $server_arr 'db_name')' | grep ^DROP | mysql -h'$(ar $server_arr 'db_host')' -u'$(ar $server_arr 'db_user')' -p'$(ar $server_arr 'db_pass')' '$(ar $server_arr 'db_name')'";

        # tell the user we're uploading the database
        echo "Uploading launch_db.sql to remote database";

        # copy ssh password to clipboard
        echo "$(ar $server_arr 'host_pass') SSH password on clipboard";
        echo "$(ar $server_arr 'host_pass')" | pbcopy;

        # cat the database file and push it live
        cat $to_launch | ssh "$(ar $server_arr 'host_user')"@"$(ar $server_arr 'host_name')" "cat - | mysql -h'$(ar $server_arr 'db_host')' -u'$(ar $server_arr 'db_user')' -p'$(ar $server_arr 'db_pass')' '$(ar $server_arr 'db_name')'";

        # tell the user we're checking the url
        echo "Checking siteurl for uploaded database";

        # copy ssh password
        echo "$(ar $server_arr 'host_pass') SSH password on clipboard";
        echo "$(ar $server_arr 'host_pass')" | pbcopy;

        # get the siteurl value
        option_value=`ssh "$(ar $server_arr 'host_user')"@"$(ar $server_arr 'host_name')" "mysql -h'$(ar $server_arr 'db_host')' -u'$(ar $server_arr 'db_user')' -p'$(ar $server_arr 'db_pass')' '$(ar $server_arr 'db_name')' -e 'SELECT option_value FROM "$(ar $server_arr 'db_table_prefix')"options WHERE option_name=\"siteurl\"'"`;
        option_value_array=($option_value);
        siteurl=${option_value_array[1]};

        # if the siteurl matches the requested one
        if [ "$siteurl" == "$(ar $server_arr 'url')" ]; then
            # report success
            alert_success "$siteurl value reported as the url";
        # if the siteurl does not match what was requested
        else
            # report actual values
            echo "url provided:                 $(ar $server_arr 'url')";
            echo "value reported as siteurl:    $siteurl";
            # report failure and exit
            alert_exit 'Database cell "siteurl" and url provided do not match'
        fi

    # if the dump file doesn't exist for upload
    else

        # report error
        alert_exit "The to-launch dump file does not exist $to_launch";

    fi

}

# make all common functions available
source "$( dirname "${BASH_SOURCE[0]}" )""/../../app/common_functions.sh";
# prep and fire this module (pass all args and this file's path)
run_module "$@" "$( dirname "${BASH_SOURCE[0]}" )";
# all done here
exit;
