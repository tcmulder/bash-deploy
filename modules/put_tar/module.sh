#!/bin/bash

# #################################################################
# Put Code Tar
# -----------------------------------------------------------------
# description: puts files onto a server as a tar file
# since version: 4.0
# #################################################################


# -----------------------------------------------------------------
# Put code on remote server
# -----------------------------------------------------------------

# module function
function module(){

    # source the configuration file and check required options
    source "$config_file";

    # establish desired input filename
    origin_directory="$dir_backup$origin_name""/code/";
    origin_file="$origin_directory$origin_name""_code.tar.gz";

    # if the tar file exists
    if [ -f $origin_file ]; then

        # copy ssh password to clipboard
        echo "$(ar $server_arr 'host_pass') SSH password on clipboard";
        echo "$(ar $server_arr 'host_pass')" | pbcopy;

        # upload the code
        remote_commands="cd $(ar $server_arr 'root_remote') && cat - > ""$origin_name""_code.tar.gz";
        cat $origin_file | pv -Wbt | ssh "$(ar $server_arr 'host_user')"@"$(ar $server_arr 'host_name')" "$remote_commands";

        # copy ssh password to clipboard
        echo "$(ar $server_arr 'host_pass') SSH password on clipboard";
        echo "$(ar $server_arr 'host_pass')" | pbcopy;

        # reconnect via ssh and cd into directory with the upload
        remote_commands="cd $(ar $server_arr 'root_remote') && echo 'Logged into directory `pwd`' && ls && bash";
        ssh -t "$(ar $server_arr 'host_user')"@"$(ar $server_arr 'host_name')" "$remote_commands";

    # # if the tar file already exists
    else
        # exit with error
        alert_exit "The tar file does not exist $origin_file";

    fi

}

# make all common functions available
source "$( dirname "${BASH_SOURCE[0]}" )""/../../app/common_functions.sh";
# prep and fire this module (pass all options and this file's path)
run_module "$@" "$( dirname "${BASH_SOURCE[0]}" )";
# all done here
exit;
