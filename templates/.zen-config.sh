#!/bin/bash

# #################################################################
# Zen Deploy Script
# -----------------
# version:      4.0
# author:       Tomas Mulder
# repo:         git@github.com:tcmulder/bash-deploy.git
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
# patterns to exclude from launch for original server
org_exclude=(
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

# new server (same as original)
new_server=(${org_server[@]});
new_exclude=(${org_exclude[@]});

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
    'db_host::localhost'
    'db_table_prefix::wp_'

    # url
    # 'url::http://YOUR_SERVER_ADDRESS/sites/__CLIENT_NAME__/__PROJECT_NAME__'

    # server directories
    # 'root_remote::~/zen_stage1/sites/__CLIENT_NAME__/' # start and end with forward slash
    # 'dir_remote::__PROJECT_NAME__' # single directory name with no slashes

);


# -----------------------------------------------------------------
# Call zen deployment script
# -----------------------------------------------------------------

source $dir_script/zen-deploy.sh
