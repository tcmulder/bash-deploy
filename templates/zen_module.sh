#!/bin/sh

# #################################################################
# SSH Into Remote Server
# Connects to server via SSH
# #################################################################

# -----------------------------------------------------------------
# Output help info
# -----------------------------------------------------------------

# output help if requested
if [ $1 == 'help' ]; then
    echo ".....................................................";
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
    big_echo "Checking for \"$some_variable\"";

    # diagnostic code here

    # if success
    if [ "$some_variable" == "$confirm" ]; then
        # show the success message
        alert_success "$success";
    # if the returned message doesn't confirm success
    else
        # show the error to the user
        alert_error "Error with $some_variable";
    fi

 	exit;
fi

# -----------------------------------------------------------------
# Actual module commands
# -----------------------------------------------------------------

# source the configuration file
source $1;

# command text here

exit;