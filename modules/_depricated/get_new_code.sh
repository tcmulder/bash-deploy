#!/bin/bash

# #################################################################
# Get Code
# -----------------------------------------------------------------
# description: grabs code from the server and saves a backup
# since version: 3.0
# #################################################################

# -----------------------------------------------------------------
# Output help info
# -----------------------------------------------------------------

# output help if requested
if [ $1 == 'help' ]; then
    echo "zen get code new ............. Download new code backup";
    exit;
fi

# -----------------------------------------------------------------
# Perform doctor diagnosis
# -----------------------------------------------------------------

# if diagnostics were requested
if [ $1 == 'doctor' ]; then
    # source the configuration file
    source $2;
    # tell the user the check is taking place
    big_echo "Checking \"$dir_remote\" Directory on \"$host_name\"";

    # copy ssh password
    echo "$host_pass SSH password on clipboard";
    echo "$host_pass" | pbcopy;

    # if the remote directory exists
    if [[ `ssh "$host_user"@"$host_name" test -d $root_remote$dir_remote && echo exists` ]]; then
        # report success
        alert_success "The $root_remote$dir_remote directory exists";
    else
        # report failure
        alert_error "The $root_remote$dir_remote directory does not exist";
    fi

    exit;

fi

# -----------------------------------------------------------------
# Backup code
# -----------------------------------------------------------------

# source the configuration file
source $1;

# establish desired output filename
dir_for_tar="$dir_backup""new/code/"
file_tar="$dir_for_tar""new_code.tar.gz";

# if the tar file doesn't already exist
if [ ! -f $file_tar ]; then

    #  if the backup directory exists
    if [ -d $dir_for_tar ]; then

        # copy ssh password to clipboard
        echo "$host_pass SSH password on clipboard";
        echo "$host_pass" | pbcopy;

        # tar and download the code
        ssh "$host_user"@"$host_name" "cd $root_remote/; tar -pzcf - $dir_remote;" | pv -Wbt | cat - > "$file_tar";

        # if the tar file now exists
        if [ -f $file_tar ]; then
            # show the size of the tared file
            echo "Size of "$file_tar;
            du -ch $file_tar | grep total;
            # report success
            alert_success "Tar of code created";
        fi

    else
        # asdf
        alert_exit "Backup directory does not exist";

    fi

# if the tar file already exists
else
    # exit with error
    alert_exit "The tar file exist $file_tar";

fi

exit;
