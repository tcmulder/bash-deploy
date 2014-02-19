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

# this config file's filename and path
config_file="${BASH_SOURCE[@]}";

# backup directories (one level up from this script)
dir_backup=$dir_config'/'`date +"%y.%m.%d"`'_'$name_project'/';

# live server directories
root_remote='/YOUR_SERVER_ADDRESS/zen_dev1/sites/iortho/'; # start and end with forward slash
dir_remote='iortho'; # single directory name with no slashes

# stage server directories
root_stage='~/zen_dev1/sites/'$name_client'/'; # start and end with forward slash
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
db_stage_name='d1_'$name_project;
db_stage_user='d1_'$name_project;
db_stage_pass='YOUR_PASSWORD';
db_stage_host='localhost';
db_stage_table_prefix='wp_';

# find and replace urls
url_stage='http://YOUR_SERVER_ADDRESS/sites/'$name_client'/'$name_project;
url='http://YOUR_SERVER_ADDRESS/sites/iortho/iortho';

# -----------------------------------------------------------------
# Common functions
# -----------------------------------------------------------------

# grab common functions
source $dir_script/functions.sh

# -----------------------------------------------------------------
# Main zen deploy function
# -----------------------------------------------------------------

function zen(){
    # grab all user the commands
    cmd="$@";
    # set up the filename of the command
    cmd_file=$dir_script"/modules/"${cmd// /_}".sh";
    # if the command file actually exists
    if [ -f $cmd_file ]; then
        # run the command file
        bash $cmd_file $dir_config"/"$config_file;
    # if the command file doesn't exist
    else
        # tell the user
        echo "$@ command not found"
    fi
}