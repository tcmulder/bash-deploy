#!/bin/bash

# #################################################################
# Find and Replace
# -----------------------------------------------------------------
# description: performs find and replace on a database
# since version: 4.0
# #################################################################

# module function
function module(){

    # source the configuration file
    source "$config_file";

    # establish desired output filename
    origin_directory="$dir_backup$origin_name""/db/";
    origin_file="$origin_directory$origin_name""_db.sql";
    to_launch="$origin_directory""launch_db.sql";

    # if the origin dump file exists
    if [ -f $origin_file ]; then

        # if the to-launch dump file already exist
        if [ -f $to_launch ]; then
            # ask whether or not to overwrite the file
            read -p "Overwrite existing to-launch dump file? [yes|NO] " confirm;
            confirm=${confirm:-no};
            # if the answer is yes
            if [ "$confirm" != 'yes' ]; then
                # exit with error
                alert_exit "Unable to overwrite dump file $file_for_backup";
            fi
        fi

        # create temporary database
        temp_db="zen_script_"$((RANDOM%9000+1000))
        mysql -uroot -proot -e "CREATE DATABASE $temp_db;" || alert_exit "Unable to create the $temp_db database";

        # grab origin db
        mysql -uroot -proot $temp_db < "$origin_file" || alert_exit "Cannot import ""$origin_file";

        # replace url
        php /Applications/MAMP/htdocs/_far/srdb.cli.php -hlocalhost -uroot -proot -n"$temp_db" -s"$(ar $origin_arr 'url')" -r"$(ar $server_arr 'url')" -vfalse;

        # dump the temporary database then drop it
        mysqldump -uroot -proot $temp_db > "$to_launch" || alert_exit "Unable to dump database into ""$to_launch";
        mysql -uroot -proot -e "DROP DATABASE $temp_db;"

        # if the dump file now exists
        if [ -f $to_launch ]; then
            # show the size of the dumped file
            echo "Size of "$to_launch;
            echo "size: "`du -ch $to_launch | grep total`;
            number_of_lines=`wc -l < "$to_launch"`;
            echo "number of lines: ""$number_of_lines";
            if [[ $number_of_lines -gt 1 ]]; then
                # report success
                alert_success "Database file dumped";
            else
                # exit with error
                alert_exit "The dump file is empty $to_launch";
            fi
        fi

    # if the origin dump does not
    else
        # exit with error
        alert_exit "No file to FAR $origin_file";

    fi

}

# make all common functions available
source "$( dirname "${BASH_SOURCE[0]}" )""/../../app/common_functions.sh";
# prep and fire this module (pass all args and this file's path)
run_module "$@" "$( dirname "${BASH_SOURCE[0]}" )";
# all done here
exit;