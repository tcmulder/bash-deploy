#!/bin/bash

# #################################################################
# Output Help
# -----------------------------------------------------------------
# description: shows the user all available commands
# since version: 3.0
# #################################################################

# -----------------------------------------------------------------
# Output help info
# -----------------------------------------------------------------

# output help if requested
if [ $1 == 'help' ]; then
	echo "zen help ..................... List available commands";
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
    big_echo 'Checking Help Resources';

    # look for modules
    for module in $dir_script/modules/*
    do
    	# get the module's name
    	module_name=$(basename "$module");
    	# ask for help output
    	help_output=`bash $module 'help'`;
    	# if the help output isn't empty
    	if [ ! -z "$help_output" ]; then
    		# show success
	    	alert_success "$module_name has help available";
    	# if the help output is empty
    	else
    		# show failure
			alert_error "$module_name has no help available";
    	fi
    done

	exit;
fi

# -----------------------------------------------------------------
# Request help for all commands
# -----------------------------------------------------------------

# source the configuration file
source $1;

# for all of the modules
for module in $dir_script/modules/*
do
	# call for help output
	bash $module 'help';
done

exit;