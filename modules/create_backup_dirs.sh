#!/bin/sh

# #################################################################
# Create Backup Directories
# creates basic backup directories for new and old code
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

dir_backup=$1;
dir_backup_org=$2;
dir_backup_new=$3;

# -----------------------------------------------------------------
# Create Backup Directories
# -----------------------------------------------------------------

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