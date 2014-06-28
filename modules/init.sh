#!/bin/sh

# #################################################################
# Init
# initialize zen-deploy script
# #################################################################

# Instructions: you'll need to add the following line to your
# bash_profile so it's aware of the initalization script. Change
# the path to match the location of this zen_init.sh file.
#
# source /Applications/MAMP/htdocs/zen-deploy/app/init.sh;

# -----------------------------------------------------------------
# Output help info
# -----------------------------------------------------------------

# output help if requested
if [ -n "$1" ] && [ "$1" == 'help' ]; then
    echo "zen init ..................... initialize/reinitialize zen-deploy";
    exit;
fi

# -----------------------------------------------------------------
# Perform doctor diagnosis
# -----------------------------------------------------------------

# if diagnostics were requested
if [ -n "$1" ] && [ "$1" == 'doctor' ]; then
    # source the configuration file
    source $2;

    # tell the user the check is taking place
    big_echo "Checking \"$(basename $name_project)\" Initialization";
    echo '(init.sh)';

    # if the project name is set
    if [ -n $name_project ]; then
        # tell the user which project is initialized
        echo "Config variable \$name_project defined as \"$name_project\""
        # report success
        alert_success "Project is initialized"
    # if no backup directory exists
    else
        # report error
        alert_error "The project is not initialized";
    fi

    exit;
fi

# -----------------------------------------------------------------
# Initialize zen-deploy
# -----------------------------------------------------------------

# zen deploy initialization function
function zen() {
    # if the user asked to initialize
    if [ "$1" == 'init' ]; then
        # grab all the zen-whatever.sh files
        zen_co_str="zen-*.sh";
        # create an array of file names
        zen_co=($zen_co_str);
        # if there is no file
        if [ ${#zen_co[@]} == 0 ]; then
            # warn the user
            echo 'No zen-*.sh config file found';
        # if there's only one file
        elif [ ${#zen_co[@]} == 1 ]; then
            # tel the user the file being used
            echo "Initializing zen-deploy using ${zen_co[0]}";
            # source the file
            source ${zen_co[0]};
            # check for updates
            source $dir_script/app/update.sh;
        # if there are more than one file
        else
            # for each file
            for zen_co_file in "${zen_co[@]}"
            do
                # ask the user if they'd like to use this file
                read -p "Use $zen_co_file? [YES|no] " confirm;
                # default to yes
                confirm=${confirm:-yes};
                # if the answer is yes
                if [ "$confirm" == yes ]; then
                    # tell the user what file is being used
                    echo "Initializing zen-deploy using $zen_co_file";
                    # source the file
                    source $zen_co_file;
                    # check for updates
                    source $dir_script/app/update.sh;
                    # exit the loop
                    break;
                fi
            done
        fi
    # if the user didn't ask for initialization
    else
        # ask if the user would like to initialize
        echo 'The zen-deploy script is not initialized';
        read -p "Would you like to run zen init? [YES|no] " confirm;
        # default to yes
        confirm=${confirm:-yes};
        # if the answer is yes
        if [ "$confirm" == yes ]; then
            # initialize
            zen init;
        fi
    fi
}