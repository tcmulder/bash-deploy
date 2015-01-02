#!/bin/bash

# #################################################################
# Put Code
# -----------------------------------------------------------------
# puts files onto a server
# since version: 4.0
# #################################################################

# module function
function module(){

    # source the configuration file
    source "$config_file" &&
    ar_var_check_exit 'server dir_remote host_name host_pass host_user root_remote';

    # establish desired output filename
    origin_directory="$dir_backup$origin_name""/code/";
    origin_file="$origin_directory$origin_name""_code.tar.gz";
    to_launch="$origin_directory""launch_code/";


    # if the code tar exists
    if [ -f $origin_file ]; then

        # if the code directory doesn't exist
        if [[ ! -d "$to_launch" ]]; then

            # create the code directory
            mkdir "$to_launch";

            # extract the backup tar with status
            echo 'extracting backup tar';
            pv "$origin_file" | tar -zxf - -C "$to_launch" --strip 1

        fi

        # copy ssh password to clipboard
        echo "$(ar $server_arr 'host_pass') SSH password on clipboard";
        echo "$(ar $server_arr 'host_pass')" | pbcopy;

        # set up rsync call
        rsync_short_options='-rlpgoDczvi';
        rsync_long_options='--progress --delete';

        # set up rsync excludes array
        rsync_exclude='';
        exclude_arr_name=$origin_exclude[@];
        exclude_arr=("${!exclude_arr_name}");
        # create an exclude long option for each array item
        if [ ${#exclude_arr[@]} != 0 ]; then
            for i in "${exclude_arr[@]}"
            do
                rsync_exclude="$rsync_exclude --exclude='$i'";
            done
        fi

        # dry run the rsync
        eval "rsync $rsync_short_options""n"" $rsync_long_options $rsync_exclude $to_launch $(ar $server_arr 'host_user')@$(ar $server_arr 'host_name'):$(ar $server_arr 'root_remote')$(ar $server_arr 'dir_remote')";
        echo "Dry run called";

        # ask if the rsync should be run (defaults to no)
        read -p "Put the code? [yes|NO] " confirm
        confirm=${confirm:-no}

        # if the rsync should be run
        if [ $confirm == 'yes' ]; then

            # copy ssh password to clipboard
            echo "$(ar $server_arr 'host_pass') SSH password on clipboard";
            echo "$(ar $server_arr 'host_pass')" | pbcopy;

            # run the rsync
            eval "rsync $rsync_short_options $rsync_long_options $rsync_exclude $to_launch $(ar $server_arr 'host_user')@$(ar $server_arr 'host_name'):$(ar $server_arr 'root_remote')$(ar $server_arr 'dir_remote')";

            # signify success of call to rsync
            alert_success "The rsync command was called";

        # if the rsync shouldn't be run then exit
        else
            alert_exit 'Unsuccessful put code command';
        fi

    # if the code directory doesn't exist
    else
        # exit with error
        alert_exit "The code tar file does not exist $origin_file";
    fi

}

# make all common functions available
source "$( dirname "${BASH_SOURCE[0]}" )""/../../app/common_functions.sh";
# prep and fire this module (pass all args and this file's path)
run_module "$@" "$( dirname "${BASH_SOURCE[0]}" )";
# all done here
exit;
