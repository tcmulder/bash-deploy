#!/bin/bash

# #################################################################
# Doctor
# -----------------------------------------------------------------
# description: checks if there are any issues with the config.sh variables
# since version: 3.0
# #################################################################

# -----------------------------------------------------------------
# Output help info
# -----------------------------------------------------------------

# output help if requested
if [ $1 == 'help' ]; then
	echo "zen doctor ................... Check configuration";
	exit;
fi

# -----------------------------------------------------------------
# Perform doctor diagnosis
# -----------------------------------------------------------------

# ignore calls to self
if [ $1 == 'doctor' ]; then
	exit;
fi

# -----------------------------------------------------------------
# Request checkup on all commands
# -----------------------------------------------------------------

# source the configuration file
source $1;

# for all of the modules
for module in $dir_script/modules/*
do
	# call for diagnosis and pass in the configuration file
    bash $module 'doctor' $1;
    echo "file: $(basename $module)";
done

exit;