#!/bin/bash

# #################################################################
# Update
# -----------------------------------------------------------------
# description: update zen-depoy if necessary on first run
# since version: 4.0
# #################################################################

# -----------------------------------------------------------------
# Update script
# -----------------------------------------------------------------

# set up git command in appropriate directory
git="git --git-dir=$dir_script/.git --work-tree=$dir_script";
# determine which branch is in use
branch="`$git rev-parse --abbrev-ref HEAD`";
# if the working directory isn't clean
if [ "`$git status --porcelain`" != '' ]; then
    # tell the user
    alert_error "Unclean git directory $dir_script";
else
    # get the local and remote sha
    local_commit="`$git rev-parse $branch`";
    remote_commit="`$git rev-parse origin/$branch`";
    # if the local sha and remote sha are not the same
    if [ $local_commit != $remote_commit ]; then
        # ask the user if they'd like to update
        echo 'zen-deploy is out of date.';
        read -p "Would you like to update? [YES|no] " confirm;
        confirm=${confirm:-yes};
        # if the answer is yes
        if [ "$confirm" == 'yes' ]; then
            # pull down changes
            $git pull origin $branch;
        fi
    # if the local sha and remote sha match
    else
        # tell the user everything's up to date
        echo 'The zen-deploy script is up to date'
    fi
fi
