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
# Put code on remote server
# -----------------------------------------------------------------

# source the configuration file
source $1;

# establish desired output filename
dir_with_tar="$dir_backup"
file_tar="$dir_with_tar""live_code.tar.gz";

# if the tar file exists
if [ -f $file_tar ]; then

    # copy ssh password to clipboard
    echo "$host_pass SSH password on clipboard";
    echo "$host_pass" | pbcopy;

    # upload the code
    remote_commands="cd $root_remote && cat - > live_code.tar.gz";
    cat $file_tar | pv | ssh "$host_user"@"$host_name" "$remote_commands";

    # copy ssh password to clipboard
    echo "$host_pass SSH password on clipboard";
    echo "$host_pass" | pbcopy;

    # reconnect via ssh and cd into directory with the upload
    remote_commands="cd $root_remote && echo 'Logged into directory `pwd`' && ls && bash";
    ssh -t "$host_user"@"$host_name" "$remote_commands";

# if the tar file already exists
else
    # exit with error
    alert_exit "The tar file does not exist $file_tar";

fi

exit;
