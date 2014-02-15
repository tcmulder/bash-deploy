#!/bin/sh

# #################################################################
# Output Help
# shows the user all available commands
# #################################################################

# -----------------------------------------------------------------
# Output Help Info
# -----------------------------------------------------------------

# output help if requested
if [ $1 == 'help' ]; then
	echo "zen help ..................... List available commands";
	exit;
fi

# -----------------------------------------------------------------
# Perform Doctor Diagnosis
# -----------------------------------------------------------------

# if help was requested
if [ $1 == 'doctor' ]; then
	# source the configuration file
	source $2;
	# tell the user the check is taking place
    big_echo 'Checking Help Resources';

	# variable to store true if any help exists
    module_help=0;
    # variable to help output
    help_output='';

    # look for modules
    for module in $dir_script/modules/*
    do

    	help_output=`bash $module 'help'`;
    	module_name=$(basename "$module");

    	if [ ! -z "$help_output" ]; then
	    	alert_success "$module_name has help available";
	    	module_help=1;
    	else
			alert_error "$module_name has no help available";
    	fi

    done

    if [ $module_help == 0 ]; then
    	alert_error "No help resources available";
    fi

    # # if there exists data in the module counter
    # if [ ! -z "$help_output" ]; then
    # 	# show the available modules
    # 	printf -- '%s\n' "${module_help[@]}"
    # 	# show success
    # 	alert_success "Help resources available"
    # # if there is no module data
    # else
    # 	# show failure
    # 	alert_error "No help resources available";
    # fi

	exit;
fi

# -----------------------------------------------------------------
# Request Help for All Commands
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