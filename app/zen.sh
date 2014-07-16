#!/bin/sh

# #################################################################
# Zen Function
# main zen function
# #################################################################

# -----------------------------------------------------------------
# Main zen deploy function
# -----------------------------------------------------------------

function zen(){
    # grab all user the commands
    cmd="$@";
    # get the first command
    cmd_first=`echo "$@" | awk '{print $1;}'`;
    # store the file path
    cmd_file=$dir_script"/modules/"${cmd// /_}".sh";
    # if the root command was called
    if [ -z $cmd_first ]; then
        echo 'No command recieved: run zen help for assistance'
    # if the command file actually exists
    elif [ -f $cmd_file ]; then
        # run the command file
        bash $cmd_file $dir_config"/"$config_file;
    # if command asks for help
    elif [ $cmd_first == 'help' ]; then
        # get the command minus "help"
        sub_cmd=`echo $cmd | sed -E 's/^.{5}//'`;
        # establish the file to check help for
        cmd_file=$dir_script"/modules/"${sub_cmd// /_}".sh";
        # if the sub command file exists
        if [ -f $cmd_file ]; then
            # check help
            bash $cmd_file 'help';
        # if the sub command file does not exist
        else
            # tell the user
            alert_error "No help for $sub_cmd found";
        fi
    # if the command asks for diagnosis
    elif [ $cmd_first == 'doctor' ]; then
        # get the command minus "doctor"
        sub_cmd=`echo $cmd | sed -E 's/^.{7}//'`;
        # establish the file to diagnose
        cmd_file=$dir_script"/modules/"${sub_cmd// /_}".sh";
        # if the sub command file exists
        if [ -f $cmd_file ]; then
            # run diagnostics
            bash $cmd_file 'doctor' $config_file;
        # if the sub command file does not exist
        else
            # tell the user
            alert_error "No diagnostics for $sub_cmd found";
        fi
    # if the command file doesn't exist
    else
        # tell the user
        alert_error "$cmd command not found";
    fi
}
