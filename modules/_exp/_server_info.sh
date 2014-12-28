#!/bin/bash

# #################################################################
# Server Info
# -----------------------------------------------------------------
# description: provides information about the server
# since version: 3.2
# #################################################################

# -----------------------------------------------------------------
# Output help info
# -----------------------------------------------------------------

# output help if requested
# if [ $1 == 'help' ]; then
#     echo "zen put tar .................. Get information about the server";
#     exit;
# fi

# -----------------------------------------------------------------
# Perform doctor diagnosis
# -----------------------------------------------------------------

# if diagnostics were requested
# if [ $1 == 'doctor' ]; then
#     # source the configuration file
#     source $2;
#     # tell the user the check is taking place
#     big_echo "Checking Directory for tar on \"$host_name\"";

#     # copy ssh password
#     echo "$host_pass SSH password on clipboard";
#     echo "$host_pass" | pbcopy;

#     # if the remote directory exists
#     if [[ `ssh "$host_user"@"$host_name" test -d $root_remote && echo exists` ]]; then
#         # report success
#         alert_success "The $root_remote directory exists";
#     else
#         # report failure
#         alert_error "The $root_remote directory does not exist";
#     fi

#     exit;

# fi

# -----------------------------------------------------------------
# Get server information
# -----------------------------------------------------------------

# source the configuration file
source $1;

# copy ssh password
echo "$host_pass SSH password on clipboard";
echo "$host_pass" | pbcopy;

# grab all the config files
config_array=(`ssh "$host_user"@"$host_name" 'pwd && find -L \`pwd\` -name "wp-config.php" -type f 2>/dev/null'`);

# list each config file path
for (( i=0; i<${#config_array[@]}; i++ ));
do
    config_file=${config_array[$i]};
    echo "config found in $config_file";
done

# report total number of config files
if [ ${#config_array[@]} -eq 0 ]; then
    echo 'no wp-config.php files found';
else
    echo "${#config_array[@]} wp-config.php files found";
fi



exit;
