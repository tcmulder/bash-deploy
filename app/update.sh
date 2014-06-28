#!/bin/sh

# #################################################################
# Update
# update zen-depoy if necessary on first run
# #################################################################

# -----------------------------------------------------------------
# Main zen deploy function
# -----------------------------------------------------------------

echo 'yet something else';
if [[ $(git --git-dir="$dir_script"/.git diff --shortstat 2> /dev/null | tail -n1) != "" ]]; then
    echo 'something';
else
    echo 'something else';
fi


# git_stat=`git --git-dir="$dir_script"/.git status status -uno`;
# echo $git_stat;



# check if on right branch and if up to date

# if the zen function hasn't been initialized yet
# if [ "`type -t zen`" != 'function' ]; then



# fi