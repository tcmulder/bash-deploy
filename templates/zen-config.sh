#!/bin/bash

# #################################################################
# Zen Deploy Script
# -----------------
# version:      4.0
# author:       Tomas Mulder <tomas@zenman.com>
# repo:         git@git.zenman.com:tcmulder/zen-deploy.git
# #################################################################

# -----------------------------------------------------------------
# Directories
# -----------------------------------------------------------------

# client and project name as used for their directories
# name_client='__CLIENT_NAME__';
# name_project='__PROJECT_NAME__';

# directory where zen deploy resides
dir_script="/Applications/MAMP/htdocs/zen-deploy";

# directory in which this script resides
dir_config="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";

# this config file's filename and path
config_file="${BASH_SOURCE[0]}";

# backup directories (one level up from this script)
dir_backup=$dir_config'/'`date +"%y.%m.%d"`'_'$name_project'/';

# -----------------------------------------------------------------
# Servers
# -----------------------------------------------------------------

# original server
org_server=(

    # ssh
    # 'host_name::0000'
    # 'host_user::0000'
    # 'host_pass::0000'

    # database
    # 'db_name::wp___PROJECT_NAME__'
    # 'db_user::wp___PROJECT_NAME__'
    # 'db_pass::0000'
    # 'db_host::localhost'
    # 'db_table_prefix::wp_'


    # url
    # 'url::http://www.__PROJECT_NAME__.com'

    # server directories
    # 'root_remote::/var/www/vhosts/__PROJECT_NAME__/' # start and end with forward slash
    # 'dir_remote::html' # single directory name with no slashes

);

# new server (same as original)
new_server=(${new_server[@]});

# staging server
stage_server=(

    # ssh
    'host_name::YOUR_SERVER_ADDRESS'
    'host_user::YOUR_USERNAME'
    'host_pass::YOUR_PASSWORD'

    # database
    # 'db_name::s1___PROJECT_NAME__'
    # 'db_user::s1___PROJECT_NAME__'
    # 'db_pass::0000'
    # 'db_host::localhost'
    # 'db_table_prefix::wp_'

    # url
    # 'url::http://YOUR_SERVER_ADDRESS/sites/__CLIENT_NAME__/__PROJECT_NAME__'

    # server directories
    # 'root_remote::~/zen_stage1/sites/__CLIENT_NAME__/' # start and end with forward slash
    # 'dir_remote::__PROJECT_NAME__' # single directory name with no slashes

);

# stage patterns to exclude from launch
stage_exclude=(
    '.db'
    '.db/db.sql'
    '.DS_Store'
    '.git'
    '.sass-cache'
    'node_modules'
    'sitemap.xml'
    'sitemap.xml.gz'
    'zen-config.php'
);



# -----------------------------------------------------------------
# Call zen deployment script
# -----------------------------------------------------------------

source $dir_script/zen-deploy.sh


































































#!/bin/bash

# #################################################################
# Zen Deploy Script
# -----------------
# version:      3.1
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

# excludes for launch
exclude_list=(
    '.db'
    '.db/db.sql'
    '.git'
    '.DS_Store'
    'sitemap.xml'
    'sitemap.xml.gz'
    '.sass-cache'
    'node_modules'
    'zen-config.php'
)

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
