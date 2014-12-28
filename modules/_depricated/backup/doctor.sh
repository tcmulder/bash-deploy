#!/bin/bash

# #################################################################
# Diagnose Backup Directories
# -----------------------------------------------------------------
# description: diagnoses issues with the backup command
# since version: 3.0
# #################################################################

# source the configuration and common function files
source $1;
source "$( dirname "${BASH_SOURCE[0]}" )"/../../app/common_functions.sh;

# tell the user the check is taking place
big_echo "Checking \"$(basename $dir_backup)\" Backup Directory";
echo '(backup.sh)';

# if the backup directory exists
if [ -d $dir_backup ]; then
    # show the file size of the backup directory
    echo "Size of "$dir_backup;
    du -ch $dir_backup | grep total;
    # report success
    alert_success "Backup directory exists"
# if no backup directory exists
else
    # report error
    alert_error "Backup directory not found";
fi

exit;
