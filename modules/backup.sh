#!/bin/sh

# #################################################################
# Create Backup Directories
# Creates basic backup directories for new and old code
# #################################################################

# -----------------------------------------------------------------
# Output help info
# -----------------------------------------------------------------

# output help if requested
if [ $1 == 'help' ]; then
	echo "zen backup ................... Create dated backup directory structure";
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
    big_echo 'Checking Backup Directory';

    # if the backup directory exists
    if [ -d $dir_backup ]; then
        # show the file size of the backup directory
        echo "Size of "$dir_backup;
        du -ch $dir_backup | grep total;
        # report success
        alert_success "Backup directory exists"
    # if no backup directory exists
    else
        # report error
        alert_error "Backup directory not found";
    fi

	exit;
fi

# -----------------------------------------------------------------
# Create backup directories
# -----------------------------------------------------------------

# source the configuration file
source $1;

# if the backup directory already exists
if [ -d "$dir_backup" ]; then
    # exit with error
    alert_exit "backup directory already exists";
fi

# make the parent backup directory and enter it
mkdir -p $dir_backup || alert_exit "backup directory could not be created";
cd $dir_backup;

# make the new and org directories
mkdir -p $dir_backup"/org";
mkdir -p $dir_backup"/new";

# enter the org directory and create code/db directories
cd $dir_backup"/org";
mkdir -p code;
mkdir -p db;

# enter the new directory and create code/db directories
cd ../;
cd $dir_backup"/new";
mkdir -p code;
mkdir -p db;

# if the backup directory now exists
if [ -d $dir_backup ]; then
    # show the size of the directory
    echo "Size of "$dir_backup;
    du -ch $dir_backup | grep total;
    # report success
    alert_success "Backup directory exists";
# if the directory doesn't exist now
else
    # exit with error
    alert_exit "Backup directory not created";
fi

exit;