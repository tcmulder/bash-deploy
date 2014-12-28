#!/bin/bash

# #################################################################
# Put Code
# puts files onto a server
# #################################################################

# -----------------------------------------------------------------
# Output help info
# -----------------------------------------------------------------

# output help if requested
if [ $1 == 'help' ]; then
    echo "zen update ................... Update zen-deploy script";
    exit;
fi

# -----------------------------------------------------------------
# Perform doctor diagnosis
# -----------------------------------------------------------------

# if diagnostics were requested
if [ $1 == 'doctor' ]; then
    # source the configuration file
    source $2;
    # tell the user the check is taking place
    big_echo "Checking \"$dir_script\" branch name";

    branch=`git --git-dir $dir_script/.git rev-parse --abbrev-ref HEAD`;

    # if the server is good
    if [[ $branch ]]; then
        # report success
        alert_success "Branch $branch exists";
    else
        # report the errors
        echo $server_check;
        # report failure
        alert_error "The branch for $dir_script is unknown";
    fi

    exit;

fi

# -----------------------------------------------------------------
# Put code on remote server
# -----------------------------------------------------------------

# source the configuration file
source $1;

# get the branch name
branch=`git --git-dir $dir_script/.git rev-parse --abbrev-ref HEAD`;
# update the branch
git --git-dir "$dir_script"/.git pull origin "$branch";

exit;