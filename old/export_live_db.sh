#!/bin/sh

# #################################################################
# Create Live Database
# dump ../live_db.sql with correct URLs
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
stage_url=$1;
url=$2;
dir_script=$3

# -----------------------------------------------------------------
# Create Live Database
# -----------------------------------------------------------------

# create temporary database
temp_db="zen_script_"$((RANDOM%9000+1000))
mysql -uroot -proot -e "CREATE DATABASE $temp_db;" || error_exit "Unable to create the $temp_db database";

# grab stage db
mysql -uroot -proot $temp_db < $dir_script/../stage_db.sql || error_exit "Cannot import $dir_script/../stage_db.sql";

# replace url
php /Applications/MAMP/htdocs/_far.php localhost root root $temp_db $stage_url $url || error_exit 'Unable to conduct find and replace on database';

# dump the temporary database then drop it
mysqldump -uroot -proot $temp_db > $dir_script/../live_db.sql || error_exit "Unable to dump database into $dir_script/../live_db.sql";
mysql -uroot -proot -e "DROP DATABASE $temp_db;"

exit;