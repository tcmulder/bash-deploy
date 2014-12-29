#!/bin/bash

# #################################################################
# SSH Into Remote Server
# -----------------------------------------------------------------
# description: connects to server via SSH
# since version: 4.0
# #################################################################

# module function
function module(){

    # source the configuration file
    source "$config_file";

    # check the server is configured
    ar_var_check_exit 'host_pass host_name host_user';

    # check to ensure a host array exists
    if [[ ! "${!server_arr}" ]]; then
        alert_exit 'Host not recognized';
    fi

    # copy ssh password to clipboard
    echo "$(ar $server_arr 'host_pass') SSH password on clipboard";
    echo "$(ar $server_arr 'host_pass')" | pbcopy;

    # ssh in
    ssh -t "$(ar $server_arr 'host_user')"@"$(ar $server_arr 'host_name')" "cd $(ar $server_arr 'root_remote')$(ar $server_arr 'dir_remote') && echo 'current directory: ' \`pwd\` && bash" || alert_exit "connection to \"$(ar $server_arr 'host_name')\" failed";

}

# make all common functions available
source "$( dirname "${BASH_SOURCE[0]}" )""/../../app/common_functions.sh";
# prep and fire this module (pass all args and this file's path)
run_module "$@" "$( dirname "${BASH_SOURCE[0]}" )";
# all done here
exit;