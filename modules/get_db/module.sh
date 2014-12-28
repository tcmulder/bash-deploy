#!/bin/bash

# #################################################################
# Get Database
# -----------------------------------------------------------------
# description: dumps a database and saves it under a given file name
# since version: 4.0
# #################################################################

# module function
function module(){

    # source the configuration file and check required options
    source "$config_file";

    # establish desired output filename
    dir_for_backup="$dir_backup$server_name""/db/"
    file_for_backup="$dir_for_backup$server_name""_db.sql";

    # if the dump file already exist
    if [ -f $file_for_backup ]; then
        # ask whether or not to overwrite the file
        read -p "Overwrite existing backup file? [yes|NO] " confirm;
        confirm=${confirm:-no};
        # if the answer is yes
        if [ "$confirm" != 'yes' ]; then
            # exit with error
            alert_exit "Unable to overwrite dump file $file_for_backup";
        fi
    fi

    # if the backup directory doesn't exist then create it
    [[ -d "$dir_for_backup" ]] || mkdir -p "$dir_for_backup";

    # copy ssh password to clipboard
    echo "$(ar $server_arr 'host_pass') SSH password on clipboard";
    echo "$(ar $server_arr 'host_pass')" | pbcopy;

    # download database dump
    ssh "$(ar $server_arr 'host_user')"@"$(ar $server_arr 'host_name')" "mysqldump -h'$(ar $server_arr 'db_host')' -u'$(ar $server_arr 'db_user')' -p'$(ar $server_arr 'db_pass')' '$(ar $server_arr 'db_name')'" | pv -Wbt | cat - > $file_for_backup;

    # if the dump file now exists
    if [ -f $file_for_backup ]; then
        # show the size of the dumped file
        echo "Size of "$file_for_backup;
        du -ch $file_for_backup | grep total;
        if [[ -s $file_for_backup ]]; then
            # report success
            alert_success "FAR database file dumped";
        else
            # exit with error
            alert_exit "The FAR dump file is empty $file_for_backup";
        fi
    fi
}

# make all common functions available
source "$( dirname "${BASH_SOURCE[0]}" )""/../../app/common_functions.sh";
# prep and fire this module (pass all options and this file's path)
run_module "$@" "$( dirname "${BASH_SOURCE[0]}" )";
# all done here
exit;