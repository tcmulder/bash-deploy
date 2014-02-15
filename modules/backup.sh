#!/bin/sh

# #################################################################
# Create Backup Directories
# creates basic backup directories for new and old code
# #################################################################

# -----------------------------------------------------------------
# Output Help Info
# -----------------------------------------------------------------

# output help if requested
if [ $1 == 'help' ]; then
	echo "zen backup ................... Create dated backup directory structure";
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
    big_echo 'Checking Backup Directory';

    if [ -d $dir_backup ]; then
        echo "Size of "$dir_backup;
        du -ch $dir_backup | grep total;
        alert_success "Backup directory exists"
    else
        alert_error "Backup directory not found";
    fi

	exit;
fi

# -----------------------------------------------------------------
# Create Backup Directories
# -----------------------------------------------------------------

# source the configuration file
source $1;

# make the parent backup directory and enter it
mkdir -p $dir_backup || error_exit "backup directory could not be created";
cd $dir_backup;

# make the new and org directories
mkdir -p $dir_backup_org;
mkdir -p $dir_backup_new;

# enter the org directory and create code/db directories
cd $dir_backup_org;
mkdir -p code;
mkdir -p db;

# enter the new directory and create code/db directories
cd ../;
cd $dir_backup_new;
mkdir -p code;
mkdir -p db;

exit;