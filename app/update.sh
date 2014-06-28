#!/bin/sh

# #################################################################
# Update
# update zen-depoy if necessary on first run
# #################################################################

# -----------------------------------------------------------------
# Update script
# -----------------------------------------------------------------

# if the zen function hasn't been initialized yet
if [ "`type -t zen`" != 'function' ]; then

    # set up git command in appropriate directory
    git="git --git-dir="$dir_script"/.git";

    # if the working directory isn't clean
    if [[ `$git status` != *"working directory clean"* ]]; then
        # tell the user
        echo 'The working directory is unclean, which could cause problems.'
        alert_error "Unclean git directory $dir_script";
    else
        # determine which branch is in use
        branch="`$git rev-parse --abbrev-ref HEAD`";
        # get the local and remote sha
        local_commit="`$git rev-parse $branch`"
        remote_commit="`$git rev-parse origin/$branch`"

        # if the local sha and remote sha are not the same
        if [ local_commit != remote_commit ]; then
            # ask the user if they'd like to update
            echo "zen-deploy is out of date.";
            read -p "Would you like to update? [YES|no] " confirm;
            confirm=${confirm:-yes};
            # if the answer is yes
            if [ "$confirm" == 'yes' ]; then
                # pull down changes
                $git pull origin/$branch;
            fi

        fi
    fi

fi