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
name_client='test-site';
name_project='test-site';

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

new_server=(

    # ssh
    'host_name::tcmulder.com'
    'host_user::tcmulder'
    'host_pass::YOUR_PASSWORD'

    # database
    'db_name::tcmulder_t2site'
    'db_user::tcmulder_t2site'
    'db_pass::zentest!!!'
    'db_host::localhost'
    'db_table_prefix::wp_'

    # url
    'url::http://test1.tcmulder.com/sites/test-site/test-site'

    # server directories
    'root_remote::/home1/tcmulder/public_html/zen_test1/sites/test-site/' # start and end with forward slash
    'dir_remote::test-site' # single directory name with no slashes

);
org_server=(${new_server[@]});

stage_server=(

    # ssh
    'host_name::tcmulder.com'
    'host_user::tcmulder'
    'host_pass::YOUR_PASSWORD'

    # database
    'db_name::tcmulder_s2site'
    'db_user::tcmulder_s2site'
    'db_pass::zentest!!!'
    'db_host::localhost'
    'db_table_prefix::wp_'

    # url
    'url::http://stage1.tcmulder.com/sites/test-site/test-site'

    # server directories
    'root_remote::/home1/tcmulder/public_html/zen_stage1/sites/test-site/' # start and end with forward slash
    'dir_remote::test-site' # single directory name with no slashes

);
stage_exclude=(
    '.db'
    '.db/db.sql'
    '.git'
    '.DS_Store'
    'sitemap.xml'
    'sitemap.xml.gz'
    '.sass-cache'
    'node_modules'
    'zen-config.php'
    'wp-config.php'

    '.htaccess'
);



# -----------------------------------------------------------------
# Call zen deployment script
# -----------------------------------------------------------------

source $dir_script/zen-deploy.sh
