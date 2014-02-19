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
    echo "zen put code ................. Put live_code.tar.gz code on remote";
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
    big_echo "Checking $dir_remote Directory";

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
# Put code on remote server
# -----------------------------------------------------------------

# copy ssh password to clipboard
echo "$host_pass SSH password on clipboard";
echo "$host_pass" | pbcopy;

# upload the code
remote_commands="cd ""$root_remote""; cat - > live_code.tar.gz";
cat $dir_script/../live_code.tar.gz | pv | ssh "$host_user"@"$host_name" "$remote_commands";

# copy ssh password to clipboard
echo "$host_pass SSH password on clipboard";
echo "$host_pass" | pbcopy;

# reconnect via ssh and cd into directory with the upload
remote_commands="cd ""$root_remote; pwd; echo 'You are logged into the server'; bash";
ssh -t "$host_user"@"$host_name" "$remote_commands";

exit;