#!/bin/sh

# #################################################################
# Output Help
# shows the user all available commands
# #################################################################

# -----------------------------------------------------------------
# Output Help Info
# -----------------------------------------------------------------

# if help was requested
if [ $1 == 'help' ]; then
	echo "zen help ..................... List available commands";
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