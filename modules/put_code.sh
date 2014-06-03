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
    echo "zen put code ................. Put project code on remote via rsync";
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

    # check the server for directory existence and rsync installation
    server_check=`ssh "$host_user"@"$host_name" test -d $root_remote$dir_remote &&  rsync --version | grep -q 'rsync  version' && echo good`;

    # if the server is good
    if [[ $server_check == 'good' ]]; then
        # report success
        alert_success "The $root_remote$dir_remote directory exists and rsync is installed";
    else
        # report the errors
        echo $server_check;
        # report failure
        alert_error "The $root_remote$dir_remote directory does not exist or rsync isn't installed";
    fi

    exit;

fi

# -----------------------------------------------------------------
# Put code on remote server
# -----------------------------------------------------------------

# source the configuration file
source $1;

# establish desired output filename
dir_with_local_code="$dir_config""/"
local_code="$dir_with_local_code""$name_project""/";

# if the code directory exists
if [ -d $local_code ]; then

    # copy ssh password to clipboard
    echo "$host_pass SSH password on clipboard";
    echo "$host_pass" | pbcopy;

    # set up rsync call
    rsync_short_options='-azcvi';
    rsync_long_options='--progress --delete';
    rsync_exclude='--exclude-from="'"$local_code"'.gitignore"';

    # dry run the rsync
    eval "rsync $rsync_short_options""n"" $rsync_long_options $rsync_exclude $local_code $host_user@$host_name:$root_remote$dir_remote";
    echo "Dry run called";

    # ask if the rsync should be run (defaults to no)
    read -p "Put the code? [yes|NO] " confirm
    confirm=${confirm:-no}

    # if the rsync should be run
    if [ $confirm == 'yes' ]; then

        # run the rsync
        eval "rsync $rsync_short_options $rsync_long_options $rsync_exclude $local_code $host_user@$host_name:$root_remote$dir_remote";

        # signify success of call to rsync
        alert_success "The rsync command was called";

    # if the rsync shouldn't be run then exit
    else

        alert_exit 'Unsuccessful put code command';

    fi

# if the code directory doesn't exist
else
    # exit with error
    alert_exit "The code directory does not exist $local_code";

fi

exit;