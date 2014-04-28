#!/bin/sh

# #################################################################
# Zen Deploy Script
# -----------------
# version:      3.0
# author:       Tomas Mulder <tomas@zenman.com>
# repo:         git@git.zenman.com:tcmulder/zen-deploy.git
# #################################################################

# -----------------------------------------------------------------
# Handle comments
# -----------------------------------------------------------------

# easy big echos
function big_echo(){
    # make a echo bar the length of the echo
    echo_bar='---';
    for((i=0; i < ${#1}; i++)); do
      echo_bar=$echo_bar"-";
    done
    # output big echo
    echo
    echo "$echo_bar";
    echo ":: $1";
    echo "$echo_bar";
}

# display colorized output
function alert_error() {
    color='\033[01;31m';    # red
    reset='\033[00;00m';    # normal
    echo -e "$color-$reset error: $1"
}
function alert_success() {
    color='\033[01;32m';    # red
    reset='\033[00;00m';    # normal
    echo -e "$color+$reset success: $1"
}
function alert_exit(){
    alert_error "$1";
    exit;
}

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
    # if the command file actually exists
    if [ -f $cmd_file ]; then
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