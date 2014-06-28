#!/bin/sh

# #################################################################
# Put Code
# puts files onto a server
# #################################################################

# -----------------------------------------------------------------
# Output help info
# -----------------------------------------------------------------

# output help if requested
if [ $1 == 'help' ]; then
    echo "zen put tar .................. Put live_code.tar.gz file on remote";
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
    big_echo "Checking Directory for tar on \"$host_name\"";

    # copy ssh password
    echo "$host_pass SSH password on clipboard";
    echo "$host_pass" | pbcopy;

    # if the remote directory exists
    if [[ `ssh "$host_user"@"$host_name" test -d $root_remote && echo exists` ]]; then
        # report success
        alert_success "The $root_remote directory exists";
    else
        # report failure
        alert_error "The $root_remote directory does not exist";
    fi

    exit;

fi

# -----------------------------------------------------------------
# Get server information
# -----------------------------------------------------------------

# source the configuration file
source $1;

echo $db_stage_name;
echo "not found, right?";

find -L . -name 'wp-config.php' -type f 2>/dev/null
# find -L . -name 'wp-config.php' -type d 2>/dev/null

# # copy ssh password to clipboard
# echo "$host_pass SSH password on clipboard";
# echo "$host_pass" | pbcopy;

# # upload the code
# remote_commands="find -L / -name 'wp-config.php' 2>/dev/null";
# wp_config=`ssh "$host_user"@"$host_name" "$remote_commands"`;
# echo "$wp_config";

exit;
