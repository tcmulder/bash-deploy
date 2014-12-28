#!/bin/bash

# #################################################################
# Title Case Module Title
# -----------------------------------------------------------------
# description: lowercase what the module does
# since version: 0.0
# #################################################################

# module function
function module(){

    # source the configuration file
    source "$config_file";

    # module code goes here (don't forget to add tests to doctor if appropriate)

}

# make all common functions available
source "$( dirname "${BASH_SOURCE[0]}" )""/../../app/common_functions.sh";
# prep and fire this module (pass all args and this file's path)
run_module "$@" "$( dirname "${BASH_SOURCE[0]}" )";
# all done here
exit;