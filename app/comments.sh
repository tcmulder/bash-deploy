#!/bin/sh

# #################################################################
# Comments
# handles a variety of comment types
# #################################################################

# -----------------------------------------------------------------
# Handle comments
# -----------------------------------------------------------------

# easy big echos
function big_echo(){
    # make a echo bar the length of the echo
    echo_bar='---';
    for((i=0; i < ${#1}; i++)); do
      echo_bar=$echo_bar"-";
    done
    # output big echo
    echo
    echo "$echo_bar";
    echo ":: $1";
    echo "$echo_bar";
}

# display colorized output
function alert_error() {
    color='\033[01;31m';    # red
    reset='\033[00;00m';    # normal
    echo -e "$color-$reset error: $1"
}
function alert_success() {
    color='\033[01;32m';    # red
    reset='\033[00;00m';    # normal
    echo -e "$color+$reset success: $1"
}
function alert_exit(){
    alert_error "$1";
    exit;
}
