#!/bin/sh

# #################################################################
# Zen Deploy Script
# version:      3.0
# author:       Tomas Mulder <tomas@zenman.com>
# repo:         git@git.zenman.com:tcmulder/zen-deploy.git
# #################################################################

# -----------------------------------------------------------------
# Directories
# -----------------------------------------------------------------

# client and project name as used for their directories
# name_client='__PROJECT_NAME__';
# name_project='__PROJECT_NAME__';

# directory where zen deploy resides
dir_script="/Applications/MAMP/htdocs/zen-deploy";

# directory in which this script resides
dir_config="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";

# this config file's filename and path
config_file="${BASH_SOURCE[@]}";

# backup directories (one level up from this script)
dir_backup=$dir_config'/'`date +"%y.%m.%d"`'_'$name_project'/';

# live server directories
# root_remote='/YOUR_SERVER_ADDRESS/zen_stage1/sites/__PROJECT_NAME__/'; # start and end with forward slash
# dir_remote='html'; # single directory name with no slashes

# stage server directories
root_stage='~/zen_stage1/sites/'$name_client'/'; # start and end with forward slash
dir_stage=$name_project; # single directory name with no slashes

# -----------------------------------------------------------------
# SSH
# -----------------------------------------------------------------

# live ssh login credentials
# host_name='YOUR_SERVER_ADDRESS';
# host_user='YOUR_USERNAME';
# host_pass='YOUR_PASSWORD';

# stage ssh login credentials
host_stage_name='YOUR_SERVER_ADDRESS';
host_stage_user='YOUR_USERNAME';
host_stage_pass='YOUR_PASSWORD';

# -----------------------------------------------------------------
# Database
# -----------------------------------------------------------------

# live database credentials
# db_name='wp___PROJECT_NAME__';
# db_user='wp___PROJECT_NAME__';
# db_pass='000000';
# db_host='localhost';
db_table_prefix='wp_';

# stage database credentials
db_stage_name='s1_'$name_project;
db_stage_user='s1_'$name_project;
# db_stage_pass='000000';
db_stage_host='localhost';
db_stage_table_prefix='wp_';

# find and replace urls
url_stage='http://YOUR_SERVER_ADDRESS/sites/'$name_client'/'$name_project;
# url='http://www.__PROJECT_NAME__.com';

# -----------------------------------------------------------------
# Call zen deployment script
# -----------------------------------------------------------------

source $dir_script/zen-deploy.sh