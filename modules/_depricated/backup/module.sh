#!/bin/bash

# #################################################################
# Create Backup Directory
# -----------------------------------------------------------------
# description: creates dated backup directory
# since version: 3.0
# #################################################################

# module function
function backup(){

    # -----------------------------------------------------------------
    # Check options
    # -----------------------------------------------------------------

    # loop through options
    local OPTIND
    while getopts ":hdq:" opt; do
        case $opt in

            # standard options
            d) doctor=true;;
            h) helps=true;;
            q) config_file="$OPTARG";;

            # custom options
            # none

            # errors
            \?) echo "Invalid option: -$OPTARG" >&2; exit;;
            :)  echo "Option -$OPTARG requires an argument." >&2; exit;;
        esac
    done

    # handle doctor requests
    if [[ $doctor == true ]]; then
        bash "$( dirname "${BASH_SOURCE[0]}" )"/doctor.sh "$config_file";
        exit;
    # handle help requests
    elif [[ $helps == true ]]; then
        bash "$( dirname "${BASH_SOURCE[0]}" )"/helps.sh;
        exit;
    fi

    # -----------------------------------------------------------------
    # Create backup directories
    # -----------------------------------------------------------------

    # source the configuration file
    source "$config_file";

    # if the backup directory already exists
    if [ -d "$dir_backup" ]; then
        # exit with error
        alert_exit "backup directory already exists";
    fi

    # make the parent backup directory and enter it
    mkdir -p $dir_backup || alert_exit "backup directory could not be created";

    # if the backup directory now exists
    if [ -d $dir_backup ]; then
        # show the size of the directory
        echo "Size of "$dir_backup;
        du -ch $dir_backup | grep total;
        # report success
        alert_success "Backup directory exists";
    # if the directory doesn't exist now
    else
        # exit with error
        alert_exit "Backup directory not created";
    fi
}

# source common functions
source "$( dirname "${BASH_SOURCE[0]}" )"/../../app/common_functions.sh;

# execute module with options
"$@";

exit;