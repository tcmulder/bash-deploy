#!/bin/sh

# #################################################################
# Establish Project Variables
# #################################################################

# -----------------------------------------------------------------
# Directories
# -----------------------------------------------------------------

# client and project name as used for their directories
# name_client='CLIENT';
# name_project='PROJECT';

# directory in which this script resides
dir_script="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";

# backup directories (one level up from this script)
dir_backup=$dir_script'/../'`date +"%y.%m.%d"`'_'$name_project'/';
dir_backup_org=$dir_backup'/org/';
dir_backup_new=$dir_backup'/new/';

# live server directories
# root_remote='/LIVE-PATH-TO-SITE/'; # start and end with forward slash
# dir_remote='html'; # single directory name with no slashes

# stage server directories
root_stage='~/zen_stage1/sites/'$name_client'/'; # start and end with forward slash
dir_stage=$name_project; # single directory name with no slashes

# -----------------------------------------------------------------
# SSH
# -----------------------------------------------------------------

# live ssh login credentials
# host_name='LIVE_SSH_SERVER';
# host_user='LIVE_SSH_USER';
# host_pass='LIVE_SSH_PASS';

# stage ssh login credentials
host_stage_name='YOUR_SERVER_ADDRESS';
host_stage_user='YOUR_USERNAME';
host_stage_pass='YOUR_PASSWORD';

# -----------------------------------------------------------------
# Database
# -----------------------------------------------------------------

# live database credentials
# db_name='wp_PROJECT';
# db_user='wp_PROJECT';
# db_pass='DB_PASSWORD';
# db_host='LIVE_DB_SERVER';
# db_table_prefix='wp_';

# stage database credentials
db_stage_name='s1_'$name_project;
db_stage_user='s1_'$name_project;
# db_stage_pass='DB_PASSWORD';
db_stage_host='localhost';
# db_stage_table_prefix='wp_';

# find and replace urls
url_stage='http://YOUR_SERVER_ADDRESS/sites/'$name_client'/'$name_project;
# url='http://www_LIVE_SITE_URL_COM';