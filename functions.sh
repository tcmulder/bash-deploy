#!/bin/sh

# #################################################################
# Common Functions
# #################################################################

# -----------------------------------------------------------------
# Handle comments
# -----------------------------------------------------------------

# easy big echos
function big_echo(){
    echo
    echo '----------------------------------------';
    echo "// $1";
    echo '----------------------------------------';
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