#!/bin/bash

# #################################################################
# Get Code
# -----------------------------------------------------------------
# description: grabs code from the server and saves a backup
# since version: 4.0
# #################################################################

# module function
function module(){

    # source the configuration file
    source "$config_file" &&
    ar_var_check_exit 'server host_pass host_user host_name root_remote dir_remote';

    # establish desired output filename
    dir_for_backup="$dir_backup$server_name""/code/"
    file_for_backup="$dir_for_backup$server_name""_code.tar.gz";

    # if the dump file already exist
    if [ -f $file_for_backup ]; then
        # ask whether or not to overwrite the file
        read -p "Overwrite existing backup file? [yes|NO] " confirm;
        confirm=${confirm:-no};
        # if the answer is yes
        if [ "$confirm" != 'yes' ]; then
            # exit with error
            alert_exit "Unable to overwrite tar file $file_for_backup";
        fi
    fi

    # if the backup directory doesn't exist then create it
    [[ -d "$dir_for_backup" ]] || mkdir -p "$dir_for_backup";

    # copy ssh password to clipboard
    echo "$(ar $server_arr 'host_pass') SSH password on clipboard";
    echo "$(ar $server_arr 'host_pass')" | pbcopy;

    # tar and download the code
    ssh "$(ar $server_arr 'host_user')"@"$(ar $server_arr 'host_name')" "cd $(ar $server_arr 'root_remote')/; tar -pzcf - $(ar $server_arr 'dir_remote');" | pv -Wbt | cat - > "$file_for_backup";

    # if the tar file now exists
    if [ -f $file_for_backup ]; then
        # show the size of the tared file
        echo "Size of "$file_for_backup;
        du -ch $file_for_backup | grep total;
        if [[ -s $file_for_backup ]]; then
            # report success
            alert_success "Tar file created";
        else
            # exit with error
            alert_exit "The tar file is empty $file_for_backup";
        fi
    fi
}

# make all common functions available
source "$( dirname "${BASH_SOURCE[0]}" )""/../../app/common_functions.sh";
# prep and fire this module (pass all args and this file's path)
run_module "$@" "$( dirname "${BASH_SOURCE[0]}" )";
# all done here
exit;
