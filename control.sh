#!/bin/sh

# #################################################################
# Controller
# Adds functions you can use to execute specific tasks
# Use zen_help for a list of functions
# #################################################################


# #################################################################
# Configure
# #################################################################

function zen(){

    # #################################################################
    # Set Up Help Function
    # #################################################################
    if [ "$1" == 'help' ]; then

        if [ "$2" == 'var' ]; then
            echo "name_project..............$name_project";
            echo "name_client...............$name_client";
            echo "dir_script................$dir_script";
            echo "dir_config................$dir_config";
            echo "script_filename...........$script_filename";
            echo "dir_backup................$dir_backup";
            echo "dir_backup_org............$dir_backup_org";
            echo "dir_backup_new............$dir_backup_new";
            echo "root_remote...............$root_remote";
            echo "dir_remote................$dir_remote";
            echo "root_stage................$root_stage";
            echo "dir_stage.................$dir_stage";
            echo "url_stage.................$url_stage";
            echo "url.......................$url";
            echo "host_name.................$host_name";
            echo "host_user.................$host_user";
            echo "host_pass.................$host_pass";
            echo "host_stage_name...........$host_stage_name";
            echo "host_stage_user...........$host_stage_user";
            echo "host_stage_pass...........$host_stage_pass";
            echo "db_stage_host.............$db_stage_host";
            echo "db_stage_user.............$db_stage_user";
            echo "db_stage_pass.............$db_stage_pass";
            echo "db_stage_name.............$db_stage_name";
            echo "db_stage_table_prefix.....$db_stage_table_prefix";
            echo "db_host...................$db_host";
            echo "db_user...................$db_user";
            echo "db_pass...................$db_pass";
            echo "db_name...................$db_name";
            echo "db_table_prefix...........$db_table_prefix";
            echo "url_stage.................$url_stage";
            echo "url.......................$url";
        else
            # create array for available functions
            functions=('----------------------------------------');
            functions+=('// Available Commands:');
            functions+=('----------------------------------------');

            # add all help documentation
            functions+=("zen help.......................List available commands");
            functions+=("zen help var...................List values of control.sh variables");
            functions+=("zen backup.....................Create datad backup directory structure");
            functions+=("zen ssh........................SSH into remote server");
            functions+=("zen get [stage|org|new] code...Download code from specified server");
            functions+=("zen get [stage|org|new] db.....Download database dump from specified server");
            functions+=("zen export db..................Export ../live_db.sql with url replaced");
            functions+=("zen drop db....................Drop live database tables");
            functions+=("zen put db.....................Put ../live_db.sql database live");
            functions+=("zen put code...................Put ../live_code.tar.gz code live");
            functions+=("zen doctor.....................Check all config.sh values");
            functions+=("zen doctor backup..............Check to ensure backup directory is set");
            functions+=("zen doctor ssh [stage].........Check SSH credentials");
            functions+=("zen doctor dir [stage].........Check path of remote directory");
            functions+=("zen doctor db [stage]..........Check database credentials");
            functions+=("zen doctor url [stage].........Check find and replace URL");

            # add an ending separator
            functions+=('----------------------------------------');

            # output all available functions
            printf -- '%s\n' "${functions[@]}"
        fi



    # #################################################################
    # Create Backup Directories
    # #################################################################
    elif [ "$1" == 'backup' ]; then
        bash $dir_script/modules/create_backup_dirs.sh $dir_backup $dir_backup_org $dir_backup_new;


    # #################################################################
    # SSH Into Remote Server
    # #################################################################
    elif [ "$1" == 'ssh' ]; then
        bash $dir_script/modules/ssh_remote.sh $host_pass $host_user $host_name;

    elif [ "$1" == 'get' ]; then

        if [ "$2" == 'stage' ]; then


            # #################################################################
            # Get Stage Code
            # #################################################################
            if [ "$3" == 'code' ]; then
                bash $dir_script/modules/get_code.sh $root_stage $dir_stage $host_stage_name $host_stage_user $host_stage_pass $dir_script 'stage';
            fi


            # #################################################################
            # Get Stage Database
            # #################################################################
            if [ "$3" == 'db' ]; then
                bash $dir_script/modules/get_db.sh '../' $host_stage_name $host_stage_user $host_stage_pass $db_stage_host $db_stage_user $db_stage_pass $db_stage_name 'stage' $dir_script;
            fi

        elif [ "$2" == 'org' ]; then


            # #################################################################
            # Backup Original Code
            # #################################################################
            if [ "$3" == 'code' ]; then
                bash $dir_script/modules/get_code.sh $root_remote $dir_remote $host_name $host_user $host_pass $dir_backup_org 'org' $dir_script;
            fi


            # #################################################################
            # Backup Original Database
            # #################################################################
            if [ "$3" == 'db' ]; then
                bash $dir_script/modules/get_db.sh $dir_backup_org $host_name $host_user $host_pass $db_host $db_user $db_pass $db_name 'org' $dir_script;
            fi

        elif [ "$2" == 'new' ]; then


            # #################################################################
            # Backup New Code
            # #################################################################
            if [ "$3" == 'code' ]; then
                bash $dir_script/modules/get_code.sh $root_remote $dir_remote $host_name $host_user $host_pass $dir_backup_new 'new' $dir_script;
            fi


            # #################################################################
            # Backup New Database
            # #################################################################
            if [ "$3" == 'db' ]; then
                bash $dir_script/modules/get_db.sh $dir_backup_new $host_name $host_user $host_pass $db_host $db_user $db_pass $db_name 'new' $dir_script;
            fi

        fi


    elif [ "$1" == 'put' ]; then


        # #################################################################
        # Put Live Code
        # #################################################################
        if [ "$2" == 'code' ]; then
            bash $dir_script/modules/put_code.sh $root_remote $dir_remote $host_name $host_user $host_pass $dir_script;
        fi


        # #################################################################
        # Put Live Database
        # #################################################################
        if [ "$2" == 'db' ]; then
            bash $dir_script/modules/put_db.sh $host_name $host_user $host_pass $db_host $db_user $db_pass $db_name $dir_script;
        fi


    # #################################################################
    # Export Live Database
    # #################################################################
    elif [ "$1" == 'export' ]; then

        if [ "$2" == 'db' ]; then
            bash $dir_script/modules/export_live_db.sh $url_stage $url $db_temp $dir_script;
        fi


    # #################################################################
    # Drop Live Database
    # #################################################################
    elif [ "$1" == 'drop' ]; then

        if [ "$2" == 'db' ]; then
            bash $dir_script/modules/drop_db.sh $host_name $host_user $host_pass $db_host $db_user $db_pass $db_name;
        fi


    # #################################################################
    # Run Zen Script Checks
    # #################################################################
    elif [ "$1" == 'doctor' ]; then
        bash $dir_script/modules/doctor.sh $dir_script $@;
    fi
}