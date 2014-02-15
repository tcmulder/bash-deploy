#!/bin/sh

# #################################################################
# Establish Project Variables
# #################################################################

# -----------------------------------------------------------------
# Directories
# -----------------------------------------------------------------

# client and project name as used for their directories
name_client='iortho';
name_project='iortho';

# directory where zen deploy resides
dir_script="/Applications/MAMP/htdocs/zen-deploy";

# directory in which this script resides
dir_config="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";

# this config file's filename
script_filename="${BASH_SOURCE[@]}";

# backup directories (one level up from this script)
dir_backup=$dir_config'/'`date +"%y.%m.%d"`'_'$name_project'/';
dir_backup_org=$dir_backup'/org/';
dir_backup_new=$dir_backup'/new/';

# live server directories
root_remote='/YOUR_SERVER_ADDRESS/zen_dev1/sites/iortho/'; # start and end with forward slash
dir_remote='iortho'; # single directory name with no slashes

# stage server directories
root_stage='~/zen_stage1/sites/'$name_client'/'; # start and end with forward slash
dir_stage=$name_project; # single directory name with no slashes

# -----------------------------------------------------------------
# SSH
# -----------------------------------------------------------------

# live ssh login credentials
host_name='YOUR_SERVER_ADDRESS';
host_user='YOUR_USERNAME';
host_pass='YOUR_PASSWORD';

# stage ssh login credentials
host_stage_name='YOUR_SERVER_ADDRESS';
host_stage_user='YOUR_USERNAME';
host_stage_pass='YOUR_PASSWORD';

# -----------------------------------------------------------------
# Database
# -----------------------------------------------------------------

# live database credentials
db_name='d1_iortho';
db_user='d1_iortho';
db_pass='YOUR_PASSWORD';
db_host='localhost';
db_table_prefix='wp_';

# stage database credentials
db_stage_name='s1_'$name_project;
db_stage_user='s1_'$name_project;
db_stage_pass='YOUR_PASSWORD';
db_stage_host='localhost';
db_stage_table_prefix='wp_';

# find and replace urls
url_stage='http://YOUR_SERVER_ADDRESS/sites/'$name_client'/'$name_project;
url='http://YOUR_SERVER_ADDRESS/sites/iortho/iortho';

# #################################################################
# Call Zen Deploy Script
# #################################################################

# source the zen deploy script
source "$dir_script"/control.sh;
echo $script_filename" was sourced";