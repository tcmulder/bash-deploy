#!/bin/bash

# #################################################################
# Diagnose Configuration
# -----------------------------------------------------------------
# description: diagnoses configuration file issues
# since version: 4.0
# #################################################################

# module function
function module(){

    # source the configuration file
    source "$config_file";

    # grab all the server arrays from the configuration file
    server_list=( $(grep '\<.*_server=' $config_file) );

    # loop through all the server arrays
    for server in "${server_list[@]}"
    do
        # get just the server name and overwrite $server_arr with it
        server_arr=$(echo "$server" | sed 's/=.*//');
        # identify which server's being checked
        big_echo "$server_arr Server Test";

        # ask if should test this server
        read -p "Check the $server_arr server configuration? [YES|no] " confirm
        confirm=${confirm:-yes};

        # if the test should run
        if [ $confirm == 'yes' ] || [ $confirm == 'YES' ]; then

            # -----------------------------------------------------------------
            # SSH Test
            # -----------------------------------------------------------------
            # tell the user the check is taking place
            big_echo "Checking SSH for \"$(ar $server_arr 'host_name')\"";

            # check if configuration is set
            var_check=`ar_var_check 'host_pass host_name host_user'`;
            # if all configuration is set
            if [[ $var_check == 'set' ]]; then

                # copy ssh password to clipboard
                echo "$(ar $server_arr 'host_pass') SSH password on clipboard";
                echo "$(ar $server_arr 'host_pass')" | pbcopy;

                # set up what success message would look like
                ssh_confirm="SSH connection to $(ar $server_arr 'host_name') successful";
                # try to connect and store the message
                ssh_return=`ssh "$(ar $server_arr 'host_user')"@"$(ar $server_arr 'host_name')" echo "$ssh_confirm"; exit;`;

                # if the returned message confirms success
                if [ "$ssh_return" == "$ssh_confirm" ]; then
                    # show the success message
                    alert_success "$ssh_return";
                # if the returned message doesn't confirm success
                else
                    # show the error to the user
                    alert_error "Error connecting via SSH $ssh_return";
                fi
            # if configuration is missing variables
            else
                # skip this test and alert missing items
                echo $var_check;
            fi

            # -----------------------------------------------------------------
            # Remote Root Directory Test
            # -----------------------------------------------------------------
            # tell the user the check is taking place
            big_echo "Checking \"$(ar $server_arr 'root_remote')\" Root Directory on \"$(ar $server_arr 'host_name')\"";

            # check if configuration is set
            var_check=`ar_var_check 'host_pass host_name host_user'`;
            # if all configuration is set
            if [[ $var_check == 'set' ]]; then

                # copy ssh password
                echo "$(ar $server_arr 'host_pass') SSH password on clipboard";
                echo "$(ar $server_arr 'host_pass')" | pbcopy;

                # if the remote directory exists
                if [[ `ssh "$(ar $server_arr 'host_user')"@"$(ar $server_arr 'host_name')" test -d $(ar $server_arr 'root_remote') && echo 'exists'` ]]; then
                    # report success
                    alert_success "The $(ar $server_arr 'root_remote') root directory exists";
                else
                    # report failure
                    alert_error "The $(ar $server_arr 'root_remote') root directory does not exist";
                fi

            # if configuration is missing variables
            else
                # skip this test and alert missing items
                echo $var_check;
            fi

            # -----------------------------------------------------------------
            # Remote Project Directory Test
            # -----------------------------------------------------------------
            # tell the user the check is taking place
            big_echo "Checking \"$(ar $server_arr 'dir_remote')\" Project Directory on \"$(ar $server_arr 'host_name')\"";

            # check if configuration is set
            var_check=`ar_var_check 'host_pass host_user host_name root_remote dir_remote'`;
            # if all configuration is set
            if [[ $var_check == 'set' ]]; then

                # copy ssh password
                echo "$(ar $server_arr 'host_pass') SSH password on clipboard";
                echo "$(ar $server_arr 'host_pass')" | pbcopy;

                # if the remote directory exists
                if [[ `ssh "$(ar $server_arr 'host_user')"@"$(ar $server_arr 'host_name')" test -d $(ar $server_arr 'root_remote')$(ar $server_arr 'dir_remote') && echo 'exists'` ]]; then
                    # report success
                    alert_success "The $(ar $server_arr 'root_remote')$(ar $server_arr 'dir_remote') project directory exists";
                else
                    # report failure
                    alert_error "The $(ar $server_arr 'root_remote')$(ar $server_arr 'dir_remote') project directory does not exist";
                fi

            # if configuration is missing variables
            else
                # skip this test and alert missing items
                echo $var_check;
            fi

            # -----------------------------------------------------------------
            # Remote RSYNC Test
            # -----------------------------------------------------------------
            big_echo "Checking rsync Compatibility on \"$(ar $server_arr 'host_name')\"";

            # check if configuration is set
            var_check=`ar_var_check 'host_pass host_user host_name'`;
            # if all configuration is set
            if [[ $var_check == 'set' ]]; then

                # copy ssh password
                echo "$(ar $server_arr 'host_pass') SSH password on clipboard";
                echo "$(ar $server_arr 'host_pass')" | pbcopy;

                # check the server rsync command
                server_check=`ssh "$(ar $server_arr 'host_user')"@"$(ar $server_arr 'host_name')" "type -P rsync &>/dev/null && echo 'Found' || echo 'Not Found'"`;

                # if the server is good
                if [[ $server_check == 'Found' ]]; then
                    # report success
                    alert_success "The rsync command is available on \"$(ar $server_arr 'host_name')\"";
                else
                    # report the errors
                    echo $server_check;
                    # report failure
                    alert_error "The rsync command is not available on \"$(ar $server_arr 'host_name')\"; you may need to use tar instead";
                fi

            # if configuration is missing variables
            else
                # skip this test and alert missing items
                echo $var_check;
            fi

            # -----------------------------------------------------------------
            # Remote TAR Test
            # -----------------------------------------------------------------
            big_echo "Checking tar Compatibility on \"$(ar $server_arr 'host_name')\"";

            # check if configuration is set
            var_check=`ar_var_check 'host_pass host_user host_name'`;
            # if all configuration is set
            if [[ $var_check == 'set' ]]; then

                # copy ssh password
                echo "$(ar $server_arr 'host_pass') SSH password on clipboard";
                echo "$(ar $server_arr 'host_pass')" | pbcopy;

                # check the server tar command
                server_check=`ssh "$(ar $server_arr 'host_user')"@"$(ar $server_arr 'host_name')" "type -P tar &>/dev/null && echo 'Found' || echo 'Not Found'"`;

                # if the server is good
                if [[ $server_check == 'Found' ]]; then
                    # report success
                    alert_success "The tar command is available on \"$(ar $server_arr 'host_name')\"";
                else
                    # report the errors
                    echo $server_check;
                    # report failure
                    alert_error "The tar command is not available on \"$(ar $server_arr 'host_name')\"";
                fi

            # if configuration is missing variables
            else
                # skip this test and alert missing items
                echo $var_check;
            fi

            # -----------------------------------------------------------------
            # Remote Database Test
            # -----------------------------------------------------------------
            # tell the user the check is taking place
            big_echo "Checking remote \"$(ar $server_arr 'db_name')\" Database";

            # check if configuration is set
            var_check=`ar_var_check 'host_pass host_user host_name db_host db_user db_pass db_name'`;
            # if all configuration is set
            if [[ $var_check == 'set' ]]; then

                # copy the ssh password
                echo "$(ar $server_arr 'host_pass') SSH password on clipboard";
                echo "$(ar $server_arr 'host_pass')" | pbcopy;

                # connect to the remote database and list tables
                ssh_return=`ssh "$(ar $server_arr 'host_user')"@"$(ar $server_arr 'host_name')" "mysql -h'$(ar $server_arr 'db_host')' -u'$(ar $server_arr 'db_user')' -p'$(ar $server_arr 'db_pass')' '$(ar $server_arr 'db_name')' -e 'SHOW TABLES'"`;
                exit_status=$?;

                # if it returns an error exit status
                if [[ $exit_status != 0 ]]; then
                    # report failure
                    alert_error 'Could not connect to database';
                # if the list of tables is empty
                elif [ ${#ssh_return} == 0 ]; then
                    echo "tables recorded:  ${#ssh_return} (the database has no tables)";
                    # report success
                    alert_success 'Connected empty to database';
                # if the tables exist
                else
                    # store the array of return data
                    table_array=($ssh_return);
                    # report number of tables found
                    echo "tables recorded:  ${#table_array[@]}";
                    # report success
                    alert_success "Connected to the \"$(ar $server_arr 'db_name')\" database";
                fi

            # if configuration is missing variables
            else
                # skip this test and alert missing items
                echo $var_check;
            fi

        # if the tests shouldn't run for this server
        else
            alert_error "No tests ran on server $server_arr";
        fi

    done

    # -----------------------------------------------------------------
    # Local Database Test
    # -----------------------------------------------------------------
    # tell the user the check is taking place
    big_echo "Checking Local Database";

    # connect to the local database and list tables
    mysql_return="`mysql -hlocalhost -uroot -proot -e 'SHOW DATABASES'`";

    # if the list of tables is empty
    if [ ${#mysql_return} == 0 ]; then
        # report failure
        alert_error 'Could not connect to local mysql server';
    # if the tables exist
    else
        # store the array of return data
        table_array=($mysql_return);
        # report number of tables found
        echo "databases recorded:  ${#table_array[@]}";
        # report success
        alert_success 'Connected to local mysql server'
    fi

}

# make all common functions available
source "$( dirname "${BASH_SOURCE[0]}" )""/../../app/common_functions.sh";
# prep and fire this module (pass all args and this file's path)
run_module "$@" "$( dirname "${BASH_SOURCE[0]}" )";
# all done here
exit;