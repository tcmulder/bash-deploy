#!/bin/bash

# #################################################################
# Zen Function
# -----------------------------------------------------------------
# description: main zen function
# since version: 4.0
# #################################################################

# -----------------------------------------------------------------
# Main zen deploy function
# -----------------------------------------------------------------

function zen(){
    # grab all user the commands
    cmd="$@";
    # get the first command
    cmd_first=`echo "$@" | awk '{print $1;}'`;
    # get the command before any options
    cmd_before_opts="${cmd%% -*}";
    # replace spaces in pre-option command
    cmd_no_spaces="${cmd_before_opts// /_}";
    # store the file path
    cmd_file=$dir_script"/modules/"$cmd_no_spaces"/module.sh";
    # if the root command was called
    if [ -z $cmd_first ] ||  [ $cmd_first == '-h' ]; then
        # just show the manual and exit
        man "$( dirname "${BASH_SOURCE[0]}" )"/man.1.sh;
    # if the command file actually exists
    elif [ -f $cmd_file ]; then
        # run the command file
        bash $cmd_file $cmd -q$dir_config"/"$config_file;
    # if the command file doesn't exist
    else
        # tell the user
        alert_error "$cmd command not found";
    fi
}
