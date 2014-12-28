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
    echo "zen get code stage ........... Download stage code backup";
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
    big_echo "Checking \"$dir_stage\" Directory on \"$host_stage_name\"";

    # copy ssh password
    echo "$host_stage_pass SSH password on clipboard";
    echo "$host_stage_pass" | pbcopy;

    # if the stage directory exists
    if [[ `ssh "$host_stage_user"@"$host_stage_name" test -d $root_stage$dir_stage && echo exists` ]]; then
        # report success
        alert_success "The $root_stage$dir_stage directory exists";
    else
        # report failure
        alert_error "The $root_stage$dir_stage directory does not exist";
    fi

    exit;

fi

# -----------------------------------------------------------------
# Backup code
# -----------------------------------------------------------------

# source the configuration file
source $1;

# establish desired output filename
dir_for_tar="$dir_backup"
file_tar="$dir_for_tar""stage_code.tar.gz";

# if the tar file doesn't already exist
if [ ! -f $file_tar ]; then

    #  if the backup directory exists
    if [ -d $dir_for_tar ]; then

        # copy ssh password to clipboard
        echo "$host_stage_pass SSH password on clipboard";
        echo "$host_stage_pass" | pbcopy;

        # tar and download the code
        ssh "$host_stage_user"@"$host_stage_name" "cd $root_stage/; tar -pzcf - $dir_stage;" | pv -Wbt | cat - > "$file_tar";

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
