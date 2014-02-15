#!/bin/sh

# #################################################################
# SSH Into Remote Server
# Connects to server via SSH
# #################################################################

# -----------------------------------------------------------------
# Handle Errors
# -----------------------------------------------------------------
function error_exit(){
    echo "* error: $1";
    exit
}

# -----------------------------------------------------------------
# Capture Arguments
# -----------------------------------------------------------------
host_pass=$1;
host_user=$2;
host_name=$3;

# -----------------------------------------------------------------
# SSH Into Remote Server
# -----------------------------------------------------------------

# copy ssh password to clipboard
echo "$host_pass SSH password on clipboard";
echo "$host_pass" | pbcopy;

# ssh in
ssh "$host_user"@"$host_name";

exit;