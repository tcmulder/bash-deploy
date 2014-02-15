#!/bin/sh

# if the doctor was called
if [ $1 == 'doctor' ]; then
	echo "zen doctor ................... Check all configuration variables";
	exit;
fi

# source the configuration file
source $1;
# echo "anything?";
# echo $1;
# echo $dir_script;
# bash "$dir_script"/backup.sh 'doctor';
# bash "$dir_script"/ssh.sh 'doctor';

for module in $dir_script/modules/*
do
  bash $module 'doctor';
done

# # #################################################################
# # Doctor
# # checks if there are any issues with the config.sh variables
# # #################################################################

# # -----------------------------------------------------------------
# # Establish Variables
# # -----------------------------------------------------------------
# dir_script=$1; # $2 will be 'doctor' and is used by parent script
# to_check=$3;
# to_check_sub=$4;

# source $dir_script/config.sh;

# # -----------------------------------------------------------------
# # Handle Comments
# # -----------------------------------------------------------------

# # easy big echos
# function big_echo(){
#     echo
#     echo '----------------------------------------';
#     echo "// $1";
#     echo '----------------------------------------';
# }

# # display colorized output
# function alert_error() {
#     color='\033[01;31m';    # red
#     reset='\033[00;00m';    # normal
#     echo -e "$color-$reset error: $1"
# }
# function alert_success() {
#     color='\033[01;32m';    # red
#     reset='\033[00;00m';    # normal
#     echo -e "$color+$reset success: $1"
# }

# # -----------------------------------------------------------------
# # Check if Today's Backup Directory Exists
# # -----------------------------------------------------------------
# function check_backup(){

#     big_echo 'Checking Backup Directory';

#     if [ -d $1 ]; then
#         $1;
#         ls -R $1 | grep ":$" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/   /' -e 's/-/|/';
#         alert_success "Backup directory exists"
#     else
#         alert_error "Backup directory not found";
#     fi
# }
# if [ "$to_check" == 'backup' ]; then
#     check_backup $dir_backup;
# fi

# # -----------------------------------------------------------------
# # Check SSH Connections
# # -----------------------------------------------------------------
# function check_ssh(){

#     big_echo "Checking $4 SSH Connection";

#     echo "$3 SSH password on clipboard";
#     echo "$3" | pbcopy;

#     ssh_confirm="SSH connection to $1 successful";
#     ssh_return=`ssh "$2"@"$1" echo "$ssh_confirm"; exit;`;

#     if [ "$ssh_return" == "$ssh_confirm" ]; then
#         alert_success "$ssh_return";
#     else
#         alert_error "Error connecting via SSH";
#     fi
# }
# if [ "$to_check" == 'ssh' ]; then
#     if [ "$to_check_sub" == 'stage' ]; then
#         check_ssh $host_stage_name $host_stage_user $host_stage_pass 'Stage';
#     else
#         check_ssh $host_name $host_user $host_pass 'Live';
#     fi
# fi

# # -----------------------------------------------------------------
# # Check Remote Directories
# # -----------------------------------------------------------------
# function check_dir(){

#     big_echo "Checking $6 Directory"

#     echo "$3 SSH password on clipboard";
#     echo "$3" | pbcopy;

#     if [[ `ssh "$2"@"$1" test -d $4$5 && echo exists` ]]; then
#         alert_success "The $4$5 directory exists";
#     else
#         alert_error "The $4$5 directory does not exist";
#     fi
# }
# if [ "$to_check" == 'dir' ]; then
#     if [ "$to_check_sub" == 'stage' ]; then
#         check_dir $host_stage_name $host_stage_user $host_stage_pass $root_stage $dir_stage 'Stage';
#     else
#         check_dir $host_name $host_user $host_pass $root_remote $dir_remote 'Live';
#     fi
# fi

# # -----------------------------------------------------------------
# # Check Remote Database
# # -----------------------------------------------------------------
# function check_db(){

#     big_echo "Checking $8 Database";

#     echo "$3 SSH password on clipboard";
#     echo "$3" | pbcopy;

#     ssh_return=`ssh "$2"@"$1" "mysql -h$4 -u$5 -p$6 $7 -e 'SHOW TABLES'"`;

#     if [ ${#ssh_return} == 0 ]; then
#         alert_error 'Could not connect to database'
#     else
#         table_array=($ssh_return);
#         for table_name in "${table_array[@]}"
#             do
#                 echo "$table_name"
#         done
#         alert_success 'Connected to database'
#     fi
# }
# if [ "$to_check" == 'db' ]; then
#     if [ "$to_check_sub" == 'stage' ]; then
#         check_db $host_stage_name $host_stage_user $host_stage_pass $db_stage_host $db_stage_user $db_stage_pass $db_stage_name 'Stage';
#     else
#         check_db $host_name $host_user $host_pass $db_host $db_user $db_pass $db_name 'Live';
#     fi
# fi

# # -----------------------------------------------------------------
# # Check URLS
# # -----------------------------------------------------------------
# function check_url(){

#     big_echo "Checking siteurl for ${10} Database";

#     echo "$3 SSH password on clipboard";
#     echo "$3" | pbcopy;

#     option_value=`ssh "$2"@"$1" "mysql -h$4 -u$5 -p$6 $7 -e 'SELECT option_value FROM $8options WHERE option_name=\"siteurl\"'"`;
#     option_value_array=($option_value);
#     siteurl=${option_value_array[1]};

#     if [ "$siteurl" == "$9" ]; then
#         alert_success "$siteurl value reported as the url";
#     else
#         echo "url provided:                 $9";
#         echo "value reported as siteurl:    $siteurl";
#         alert_error 'Database cell "siteurl" and url provided do not match'
#     fi

# }
# if [ "$to_check" == 'url' ]; then
#     if [ "$to_check_sub" == 'stage' ]; then
#         check_url $host_stage_name $host_stage_user $host_stage_pass $db_stage_host $db_stage_user $db_stage_pass $db_stage_name $db_stage_table_prefix $url_stage 'Stage';
#     else
#         check_url $host_name $host_user $host_pass $db_host $db_user $db_pass $db_name $db_table_prefix $url 'Live';
#     fi
# fi

# # -----------------------------------------------------------------
# # If Nothing was Passed In
# # -----------------------------------------------------------------
# if [ ! $to_check ]; then

#     echo 'Running all checks';

#     check_backup $dir_backup;
#     check_ssh $host_stage_name $host_stage_user $host_stage_pass 'Stage';
#     check_ssh $host_name $host_user $host_pass 'Live';
#     check_dir $host_stage_name $host_stage_user $host_stage_pass $root_stage $dir_stage 'Stage';
#     check_dir $host_name $host_user $host_pass $root_remote $dir_remote 'Live';
#     check_db $host_stage_name $host_stage_user $host_stage_pass $db_stage_host $db_stage_user $db_stage_pass $db_stage_name 'Stage';
#     check_db $host_name $host_user $host_pass $db_host $db_user $db_pass $db_name 'Live';
#     check_url $host_stage_name $host_stage_user $host_stage_pass $db_stage_host $db_stage_user $db_stage_pass $db_stage_name $db_stage_table_prefix $url_stage 'Stage';
#     check_url $host_name $host_user $host_pass $db_host $db_user $db_pass $db_name $db_table_prefix $url 'Live';
# fi

exit;