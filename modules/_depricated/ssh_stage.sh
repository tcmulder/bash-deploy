#!/bin/bash

# #################################################################
# SSH Into Remote Server
# -----------------------------------------------------------------
# description: connects to server via SSH
# since version: 3.2
# #################################################################

# -----------------------------------------------------------------
# Output help info
# -----------------------------------------------------------------

# output help if requested
if [ $1 == 'help' ]; then
	echo "zen ssh ...................... SSH into stage server";
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
    big_echo "Checking SSH for \"$host_stage_name\"";

    # copy ssh password to clipboard
    echo "$host_stage_pass SSH password on clipboard";
    echo "$host_stage_pass" | pbcopy;

    # set up what success message would look like
    ssh_confirm="SSH connection to $host_stage_name successful";
    # try to connect and store the message
    ssh_return=`ssh "$host_stage_user"@"$host_stage_name" echo "$ssh_confirm"; exit;`;

    # if the returned message confirms success
    if [ "$ssh_return" == "$ssh_confirm" ]; then
        # show the success message
        alert_success "$ssh_return";
    # if the returned message doesn't confirm success
    else
        # show the error to the user
        alert_error "Error connecting via SSH $ssh_return";
    fi

 	exit;
fi

# -----------------------------------------------------------------
# SSH Into remote server
# -----------------------------------------------------------------

# source the configuration file
source $1;

# copy ssh password to clipboard
echo "$host_stage_pass staging SSH password on clipboard";
echo "$host_stage_pass" | pbcopy;

# ssh in
ssh -t "$host_stage_user"@"$host_stage_name" "cd $root_stage$dir_stage && echo 'current directory: ' \`pwd\` && bash" || alert_exit "connection to \"$host_stage_name\" failed";

exit;
