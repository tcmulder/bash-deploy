#!/bin/sh

# #################################################################
# Put Code
# puts files onto a server
# #################################################################

# -----------------------------------------------------------------
# Capture Arguments
# -----------------------------------------------------------------
root_remote=$1;
dir_remote=$2;
host_name=$3;
host_user=$4;
host_pass=$5;
dir_script=$6;

# -----------------------------------------------------------------
# Put Code
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