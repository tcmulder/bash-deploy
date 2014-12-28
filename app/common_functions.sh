#!/bin/bash

# #################################################################
# Common Functions
# -----------------------------------------------------------------
# description: sets up common functions zen-deploy uses within it's scripts
# since version: 4.0
# #################################################################

# -----------------------------------------------------------------
# Module and Option Preparation (shared module initial tasks)
# -----------------------------------------------------------------

# prepare module to run (all shared module tasks)
function run_module(){
    # identify the calling script
    calling_script="${@: -1}";
    # get the full command
    full_cmd="$@";
    # get options only
    opts="-${full_cmd#* -}";
    # send the options off for parsing
    function send_opts(){
        parse_opts -c"$calling_script" "$@";
    }
    send_opts $opts;
    # execute module with options
    module $opts;
}

# parse through given options and establish variables
function parse_opts(){

    # loop through options
    local OPTIND
    while getopts ":hq:s:o:c:v" opt; do
        case $opt in

            # options
            h) helps=true;;
            q) config_file="$OPTARG";;
            c) calling_script="$OPTARG";;
            s) server_name="$OPTARG" && server_arr=$server_name"_server";;
            o) origin_name="$OPTARG" && origin_arr=$origin_name"_server" && origin_exclude=$origin_name"_exclude";;
            v) verbose=true;;

            # errors
            \?) alert_exit "Invalid option: -$OPTARG" >&2;;
            :)  alert_exit "Option -$OPTARG requires an argument." >&2;;
        esac
    done

    # confirm the configuration file is set up
    if [[ $config_file == '' ]]; then
        alert_exit 'Your options appear incomplete (or no config file found)';
    # handle help requests
    elif [[ $helps == true ]]; then
        man "$calling_script"/man.1.sh;
        exit;
    fi
}

# -----------------------------------------------------------------
# Array Functions
# -----------------------------------------------------------------

# search through normal array as associative
function ar(){
    # eventually store the requested value
    value=false;
    # identify the array to use
    array_name=$1[@];
    # identify the key to look for
    search_term=$2;
    # establish the array
    array_values=("${!array_name}");
    # for every value in the array
    for var in "${array_values[@]}" ; do
        # look at the key
        key=${var%%::*};
        # if this is the key being searched for
        if [ "$key" == "$search_term" ]; then
            # parse the value
            value=${var#*::};
            # echo the value
            echo $value;
        fi
    done
    # identify nonexistent values
    if [[ $value == false ]]; then
        echo 'NO_VALUE';
    fi
}

# check array of required variables
function ar_var_check {
    # store missing variables
    miss='';
    # set up arguments as array
    arg_arr=($@);
    # for all arguments
    for var in "${arg_arr[@]}"; do
        # check the value reported in the configuration
        val="$(ar $server_arr $var)";
        # if there's no value
        if [[ $val == 'NO_VALUE' ]]; then
            # add the variable name to the missing list
            miss+="\"$var\" ";
        fi
    done
    # if there are any missing variables in the configuration
    if [[ $miss != '' ]]; then
        # alert the user what variables were missing
        alert_error "The server is not configured for this test: missing $miss";
    # if all the variables are set then report all set for testing
    else
        echo 'set';
    fi
}

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
